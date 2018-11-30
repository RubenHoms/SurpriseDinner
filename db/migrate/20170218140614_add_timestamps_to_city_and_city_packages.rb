class AddTimestampsToCityAndCityPackages < ActiveRecord::Migration
  def change
    add_column :cities, :created_at, :datetime
    add_column :cities, :updated_at, :datetime

    add_column :city_packages, :created_at, :datetime
    add_column :city_packages, :updated_at, :datetime
  end
end
