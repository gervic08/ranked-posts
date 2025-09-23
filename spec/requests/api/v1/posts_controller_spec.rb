# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:validated_attributes) do
      {
        title: 'A title',
        body: 'Some content',
        user_login: user_login,
        ip: '192.168.0.1'
      }
    end

    context 'when user with user_login does not exist' do
      let!(:user_login) { 'newuser' }

      it 'returns a new user and a post' do
        post api_v1_posts_path, params: validated_attributes, as: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('A title')
        expect(JSON.parse(response.body)['body']).to eq('Some content')
        expect(JSON.parse(response.body)['user_ip']).to eq('192.168.0.1')
        expect(JSON.parse(response.body)['user']['login']).to eq('newuser')
      end
    end

    context 'when user with user_login exists' do
      let!(:user_login) { user.login }

      it 'returns the existing user and a post' do
        post api_v1_posts_path, params: validated_attributes, as: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('A title')
        expect(JSON.parse(response.body)['user_ip']).to eq('192.168.0.1')
        expect(JSON.parse(response.body)['user']['login']).to eq(user.login)
      end
    end

    context 'when parameters are invalid' do
      before do
        allow_any_instance_of(Contracts::Posts::Create).to receive(:call)
          .and_return(double(success?: false, errors: { title: ['is required'] }))
      end

      let!(:user_login) { user.login }
      it 'returns unprocessable entity status' do
        post api_v1_posts_path, params: validated_attributes, as: :json

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
