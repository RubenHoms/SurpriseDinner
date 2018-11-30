class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.timestamps null: false
      t.string :name
      t.string :telephone
      t.string :email
      t.string :address
    end
  end
end
