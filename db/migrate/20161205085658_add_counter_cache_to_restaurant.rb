class AddCounterCacheToRestaurant < ActiveRecord::Migration
  def up
    add_column :restaurants, :number_of_packages, :integer, default: 0

    Restaurant.reset_column_information
    Restaurant.find_each do |r|
      Restaurant.update_counters r.id, number_of_packages: r.package_deals.length
    end
  end

  def down
    remove_column :restaurants, :number_of_packages
  end
end
