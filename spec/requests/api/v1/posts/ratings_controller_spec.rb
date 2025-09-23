# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Posts::RatingsController do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:post_record) { create(:post) }
    let!(:existing_rating) { create(:rating, post: post_record, value: 3) }
    let(:validated_attributes) do
      {
        user_id: user.id,
        post_id: post_record.id,
        value: 4
      }
    end

    context 'when parameters are valid' do
      it 'creates a new rating and returns the post average rating' do
        post api_v1_ratings_path(post_record), params: validated_attributes, as: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['post_average_rating']).to eq(3.5)
      end
    end

    context 'when parameters are invalid' do
      before do
        allow_any_instance_of(Contracts::Ratings::Create).to receive(:call)
          .and_return(double(success?: false, errors: { value: ['must be between 1 and 5'] }))
      end

      it 'returns unprocessable entity status' do
        post api_v1_ratings_path(post_record), params: validated_attributes, as: :json

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
