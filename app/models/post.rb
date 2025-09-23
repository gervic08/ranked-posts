# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy

  def add_rating!(user:, value:)
    transaction do
      ratings.create!(user: user, value: value)
      new_average = ratings.average(:value).to_f
      update_column(:rating_average, new_average)
    end
  end
end
