# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy

  def add_rating!(user:, value:)
    with_lock do
      ratings.create!(user: user, value: value)
      update_column(:rating_average, ratings.average(:value).to_f)
    end
  end
end
