# frozen_string_literal: true

class Api::V1::Posts::RatingsController < ApplicationController
  before_action :load_user, only: [:create]
  before_action :set_post, only: [:create]

  def create
    validation = Contracts::Ratings::Create.new.call(hash_params)

    if validation.success?
      rating_params = validation.to_h
      rating = post.add_rating!(user: user, value: rating_params[:value])

      render json: { post_average_rating: post.rating_average }, status: :created
    else
      render json: { errors: validation.errors.to_h }, status: :unprocessable_entity
    end
  end

  private

  attr_reader :user, :post

  def set_post
    @post = Post.find_by!(id: params[:post_id])
  end

  def load_user
    @user = User.find_by!(id: params[:user_id])
  end

  def hash_params
    @hash_params ||= params.to_unsafe_hash
  end
end
