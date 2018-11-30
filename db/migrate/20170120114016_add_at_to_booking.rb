class AddAtToBooking < ActiveRecord::Migration
  def up
    add_column :bookings, :at, :datetime
    migrate_bookings_datetime_fields
  end

  def down
    remove_column :bookings, :at
  end

  def migrate_bookings_datetime_fields
    Booking.all.each do |booking|
      booking.update_columns(at: Time.zone.parse("#{booking[:date].strftime('%Y-%m-%d')} #{booking[:time].strftime('%H:%M')}").to_datetime) if booking[:date] && booking[:time]
    end
  end
end
