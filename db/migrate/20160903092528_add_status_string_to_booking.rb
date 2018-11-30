class AddStatusStringToBooking < ActiveRecord::Migration
  def up
    add_column :bookings, :status, :string
  end

  def down
    remove_column :bookings, :status
  end
end
