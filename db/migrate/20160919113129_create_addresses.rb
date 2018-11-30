class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :street_number
      t.string :zip_code
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude
      t.string :telephone
      t.string :telephone_normalized
      t.string :email
      t.string :addressable_type
      t.integer :addressable_id
      t.timestamps null: false
    end
  end
end
