class AddNormalizedTelephoneNumberToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :telephone_normalized, :string
  end
end
