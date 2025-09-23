# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Posts::IpsController do
  describe 'GET #index' do
    let(:user1) { create(:user, login: 'user1') }
    let(:user2) { create(:user, login: 'user2') }
    let(:user3) { create(:user, login: 'user3') }

    let!(:post1) { create(:post, user: user1, ip: IPAddr.new('192.168.0.1')) }
    let!(:post2) { create(:post, user: user2, ip: IPAddr.new('192.168.0.1')) }
    let!(:post3) { create(:post, user: user3, ip: IPAddr.new('127.0.0.1')) }
    let!(:post4) { create(:post, user: user1, ip: IPAddr.new('127.1.1.1')) }
    let!(:post5) { create(:post, user: user2, ip: IPAddr.new('178.0.0.2')) }
    let!(:post6) { create(:post, user: user2, ip: IPAddr.new('127.0.0.1')) }

    it 'returns IPs used by multiple users with their logins' do
      get api_v1_ips_path

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match_array([
                                                         { 'ip' => '192.168.0.1', 'authors_logins' => %w[user1 user2] },
                                                         { 'ip' => '127.0.0.1', 'authors_logins' => %w[user2 user3] }
                                                       ])
    end
  end
end
