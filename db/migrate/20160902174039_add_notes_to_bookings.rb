class AddNotesToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :notes, :text, null: false
  end
end
