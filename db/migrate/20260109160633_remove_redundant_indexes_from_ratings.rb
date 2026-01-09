# frozen_string_literal: true

class RemoveRedundantIndexesFromRatings < ActiveRecord::Migration[8.0]
  def change
    remove_index :ratings, :post_id
    remove_index :ratings, :user_id
  end
end

