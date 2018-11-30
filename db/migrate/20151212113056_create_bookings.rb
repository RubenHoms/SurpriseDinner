class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.timestamps null: false
      t.string :first_name
      t.string :last_name
      t.integer :telephone
      t.string :email
    end
  end
end
