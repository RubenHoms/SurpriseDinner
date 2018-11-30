class RemoveDateAndTimeFieldsFromBooking < ActiveRecord::Migration
  def up
    remove_column :bookings, :date
    remove_column :bookings, :time
  end

  def down
    add_column :bookings, :date, :datetime
    add_column :bookings, :time, :datetime
  end
end
