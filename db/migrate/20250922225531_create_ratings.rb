class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :value, null: false
      t.check_constraint "value BETWEEN 1 AND 5", name: "value_range"

      t.timestamps
    end
  end
end
