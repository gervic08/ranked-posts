# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :post

  VALUE_RANGE = (1..5)
  private_constant :VALUE_RANGE

  validates :value, presence: true, inclusion: { in: VALUE_RANGE }
  validates :user_id, presence: true, uniqueness: { scope: :post_id, message: 'has already rated this post' }
  validates :post_id, presence: true
end
