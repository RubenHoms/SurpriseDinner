class AddRelationsToTables < ActiveRecord::Migration
  def change
    add_reference(:kitchens, :restaurant)
    add_reference(:codes, :booking)
    add_reference(:payments, :booking)
    add_reference(:bookings, :restaurant)
    add_reference(:bookings, :package)
  end
end
