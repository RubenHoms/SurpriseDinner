class AddSlugToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :slug, :string
  end
end
