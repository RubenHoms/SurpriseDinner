class AddNumberOfPeopleToBooking < ActiveRecord::Migration
  def change
    change_table :bookings do |t|
      t.integer :people
    end
  end
end
