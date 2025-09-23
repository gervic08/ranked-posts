# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  describe '#add_rating!' do
    let(:post) { create(:post) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'calculates the correct average rating when multiple ratings are added concurrently' do
      threads = []
      threads << Thread.new { post.add_rating!(user: user1, value: 4) }
      threads << Thread.new { post.add_rating!(user: user2, value: 2) }
      threads.each(&:join)

      post.reload
      expect(post.rating_average).to eq(3.0)
      expect(post.ratings.count).to eq(2)
    end
  end
end
