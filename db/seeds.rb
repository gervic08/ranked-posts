# frozen_string_literal: true

require 'json'
require 'net/http'
require 'benchmark'

API_URL = 'http://localhost:3000/api/v1'

CONFIG = {
  num_users: 100,
  num_ips: 50,
  num_posts: 200_000,
  rating_ratio: 0.75,
  threads: 20
}.freeze

def get_http_connection
  Thread.current[:http_connection] ||= begin
    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 10
    http.start
    http
  end
end

def api_post(path, payload)
  http = get_http_connection
  request = Net::HTTP::Post.new("/api/v1#{path}", { 'Content-Type' => 'application/json' })
  request.body = payload.to_json
  response = http.request(request)
  JSON.parse(response.body)
rescue StandardError => e
  puts "API Error: #{e.message}"
  # Reset connection on error
  Thread.current[:http_connection]&.finish rescue nil
  Thread.current[:http_connection] = nil
  nil
end

def generate_user_logins(number)
  Array.new(number) { |i| "user#{i + 1}" }
end

def generate_ips(number)
  puts "Generating #{number} unique IPs..."
  Array.new(number) { "#{rand(1..255)}.#{rand(0..255)}.#{rand(0..255)}.#{rand(0..255)}" }
end

def create_post(user_login, ip, title, body)
  api_post('/posts', { title: title, body: body, user_login: user_login, ip: ip })
end

def create_rating(post_id, user_id, value)
  api_post('/posts/ratings', { post_id: post_id, user_id: user_id, value: value })
end

def create_posts_and_ratings(logins, ips, config)
  batch_size = config[:num_posts] / config[:threads]
  threads = []
  mutex = Mutex.new
  total_created = 0

  puts "Creating #{config[:num_posts]} posts and (~#{(config[:num_posts] * config[:rating_ratio]).to_i} ratings)..."
  puts "Using #{config[:threads]} threads with #{batch_size} posts each..."

  config[:threads].times do |t|
    threads << Thread.new do
      votes_registry = Hash.new { |h, k| h[k] = Set.new }
      start_idx = t * batch_size
      end_idx = start_idx + batch_size - 1

      (start_idx..end_idx).each do |i|
        user_login = logins.sample
        ip = ips.sample
        title = "Post #{i + 1}"
        body = "Body del post #{i + 1}"

        post = create_post(user_login, ip, title, body)
        next unless post && post['id']

        post_id = post['id']
        user_id = post.dig('user', 'id')

        if rand < config[:rating_ratio] && user_id
          rating_user_login = logins.sample
          unless votes_registry[post_id].include?(rating_user_login)
            rating_value = rand(1..5)
            # Use a different user for rating
            rating_user_id = (logins.index(rating_user_login) || 0) + 1
            create_rating(post_id, rating_user_id, rating_value)
            votes_registry[post_id] << rating_user_login
          end
        end

        mutex.synchronize do
          total_created += 1
          puts "Created #{total_created} posts..." if (total_created % 10_000).zero?
        end
      end

      Thread.current[:http_connection]&.finish rescue nil
    end
  end

  threads.each(&:join)
  puts 'Seeds Completed!'
end

puts '=' * 60
puts 'IMPORTANT: Make sure the Rails server is running on port 3000'
puts 'Run: bin/rails server'
puts '=' * 60
puts ''

total_time = Benchmark.measure do
  logins = generate_user_logins(CONFIG[:num_users])
  ips = generate_ips(CONFIG[:num_ips])
  create_posts_and_ratings(logins, ips, CONFIG)
end

puts 'All done!'
puts "Total time to seed: #{total_time.real.round(2)} seconds"
