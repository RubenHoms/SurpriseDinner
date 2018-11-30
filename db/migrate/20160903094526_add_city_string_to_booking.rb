class AddCityStringToBooking < ActiveRecord::Migration
  def up
    add_column :bookings, :city, :string
  end

  def down
    remove_column :bookings, :city
  end
end
