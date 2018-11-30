class RenamePeopleInBookingToPersons < ActiveRecord::Migration
  def change
    rename_column :bookings, :people, :persons
  end
end
