class AddDateFieldToBooking < ActiveRecord::Migration
  def change
    change_table :bookings do |t|
      t.datetime :time
    end
  end
end
