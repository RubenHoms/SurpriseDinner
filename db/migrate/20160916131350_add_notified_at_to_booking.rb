class AddNotifiedAtToBooking < ActiveRecord::Migration
  def up
    add_column :bookings, :notified_at, :datetime
  end

  def down
    remove_column :bookings, :notified_at
  end
end
