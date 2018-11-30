class AddPersonalMessageToBooking < ActiveRecord::Migration
  def up
    add_column :bookings, :personal_message, :text
  end

  def down
    remove_column :bookings, :personal_message
  end
end
