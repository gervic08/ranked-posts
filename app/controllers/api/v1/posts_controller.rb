# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      before_action :load_user, only: [:create]

      def index
        posts = Post.order(rating_average: :desc)
        pagy, posts = pagy(posts, items: 10)
        posts = posts.limit(params.fetch(:top, posts.count))

        render json: PostBlueprint.render(
          posts,
          view: :index,
          root: :posts,
          meta: {
            page: pagy.page,
            per_page: pagy.vars[:items],
            total_pages: pagy.pages,
            total_count: pagy.count
          }
        ), status: :ok
      end

      def create
        validation = Contracts::Posts::Create.new.call(hash_params)

        if validation.success?
          input = validation.to_h
          post = user.posts.create!(input)
          render json: PostBlueprint.render(post), status: :created
        else
          render json: { errors: validation.errors.to_h }, status: :unprocessable_content
        end
      end

      private

      attr_reader :user

      def hash_params
        @hash_params ||= params.to_unsafe_hash.slice(:title, :body, :ip)
      end

      def load_user
        @user = User.find_or_create_by!(login: params[:user_login]) if params[:user_login].present?
      end
    end
  end
end
