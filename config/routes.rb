# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :create]
      scope :posts do
        resources :ratings, only: [:create], controller: 'posts/ratings'
      end
    end
  end
end
