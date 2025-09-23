# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'benchmark'

API_URL = 'http://localhost:3000/api/v1'


CONFIG = {
  num_users: 100,
  num_ips: 50,
  num_posts: 20_000,
  rating_ratio: 0.75,
  threads: 10
}.freeze
def api_post(path, payload)
  cmd = %(curl -s -X POST "#{API_URL}#{path}" -H "Content-Type: application/json" -d '#{payload.to_json}')
  JSON.parse(`#{cmd}`)
end

def generate_sample_logins(number)
  Array.new(number) { "user#{rand(1..1000)}" }
end

def generate_ips(number)
  puts "Generating #{number} unique IPs..."
  Array.new(number) { "#{rand(1..255)}.#{rand(0..255)}.#{rand(0..255)}.#{rand(0..255)}" }
end

def create_post(user_login, ip, title, body)
  api_post('/posts', { title: title, body: body, user_login: user_login, ip: ip })
end

def create_rating(post_id, user_id, value)
  api_post('/posts/ratings', { post_id: post_id, user_id: user_id, value: value})
end

def create_posts_and_ratings(logins, ips, config)
  votes_registry = Hash.new { |h, k| h[k] = Set.new }
  batch_size = config[:num_posts] / config[:threads]
  threads = []


  puts "Creating #{config[:num_posts]} posts and (~#{(config[:num_posts] * config[:rating_ratio]).to_i} ratings)..."

  config[:threads].times do |t|
    threads << Thread.new do
      start_idx = t * batch_size
      end_idx = start_idx + batch_size - 1
      (start_idx..end_idx).each do |i|
        user_login = logins.sample
        ip = ips.sample
        title = "Post #{i + 1}"
        body  = "Body del post #{i + 1}"

        post = create_post(user_login, ip, title, body)

        post_id = post['id']
        user_id = post['user']['id']

        next unless rand < config[:rating_ratio]
        rating_user_login = logins.sample
        next if votes_registry[post_id].include?(rating_user_login)

        rating_value = rand(1..5)
        create_rating(post_id, user_id, rating_value)
        votes_registry[post_id] << rating_user_login
      end
    end
  end

  threads.each(&:join)
  puts 'Seeds Completed!'
end

total_time = Benchmark.measure do
  sample_logins = generate_sample_logins(CONFIG[:num_users])
  ips = generate_ips(CONFIG[:num_ips])
  create_posts_and_ratings(sample_logins, ips, CONFIG)
end
puts 'All done!'
puts "Total time to seed: #{total_time.real.round(2)} seconds"
