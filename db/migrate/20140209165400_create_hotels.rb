class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :title
      t.string :description
      t.string :address
      t.string :photoUrl
      t.integer :price
      t.integer :rate
      t.boolean :breakfast

      t.timestamps
    end
  end
end
