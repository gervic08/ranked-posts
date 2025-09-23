# frozen_string_literal: true

module Contracts
  module Ratings
    class Create < Dry::Validation::Contract
      params do
        required(:post_id).filled(:integer)
        required(:user_id).filled(:integer)
        required(:value).filled(:integer)
      end

      rule(:user_id) do
        key.failure('has already rated this post') if Rating.exists?(user_id: value, post_id: values[:post_id])
      end

      rule(:value) do
        key.failure('must be between 1 and 5') unless (1..5).cover?(value)
      end
    end
  end
end