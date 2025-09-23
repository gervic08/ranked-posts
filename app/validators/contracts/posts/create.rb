# frozen_string_literal: true

require 'resolv'

module Contracts
  module Posts
    class Create < Dry::Validation::Contract
      params do
        required(:title).filled(:string)
        required(:body).filled(:string)
        required(:ip).filled(:string)
      end

      rule(:ip) do
        key.failure('is not a valid IP address') unless value =~ ::Resolv::IPv4::Regex || value =~ ::Resolv::IPv6::Regex
      end
    end
  end
end
