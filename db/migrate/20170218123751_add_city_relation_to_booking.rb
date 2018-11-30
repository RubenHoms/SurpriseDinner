class AddCityRelationToBooking < ActiveRecord::Migration
  def change
    rename_column :bookings, :city, :city_string
    create_initial_cities
    add_column :bookings, :city_id, :integer
    migrate_cities
    remove_column :bookings, :city_string
  end

  def create_initial_cities
    cities = Booking.all.map(&:city_string).uniq
    cities.each do |city|
      City.create(name: city.capitalize) unless City.exists?(name: city.capitalize)
    end
  end

  def migrate_cities
    Booking.all.each do |booking|
      city = City.find_by(name: booking.city_string.capitalize)
      booking.update_columns(city_id: city.id)
    end
  end
end
