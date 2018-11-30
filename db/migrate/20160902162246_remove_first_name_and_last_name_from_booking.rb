class RemoveFirstNameAndLastNameFromBooking < ActiveRecord::Migration
  def up
    remove_columns :bookings, :first_name, :last_name
    add_column :bookings, :name, :string
  end

  def down
    remove_column :bookings, :name
    add_column :bookings, :first_name, :string
    add_column :bookings, :last_name, :string
  end
end
