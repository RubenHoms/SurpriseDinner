class AddTokenToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :token, :string, null: false
  end
end
