class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :hotel_id
      t.integer :score

      t.timestamps
    end
  end
end
