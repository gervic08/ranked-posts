# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contracts::Posts::Create do
  subject(:contract) { described_class.new }

  let(:valid_params) do
    {
      title: 'A title',
      body: 'Some content',
      ip: '192.168.0.1'
    }
  end

  it 'is valid with correct parameters' do
    result = contract.call(valid_params)
    expect(result).to be_success
  end

  it 'fails if a required field is missing' do
    params = valid_params.except(:title)
    result = contract.call(params)
    expect(result).to be_failure
    expect(result.errors[:title]).to be_present
  end

  it 'fails if user_ip is invalid' do
    params = valid_params.merge(ip: 'not_an_ip')
    result = contract.call(params)
    expect(result).to be_failure
    expect(result.errors[:ip]).to include('is not a valid IP address')
  end
end
