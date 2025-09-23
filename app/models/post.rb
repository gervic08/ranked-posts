# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 5000 }
  validates :ip, presence: true
end
