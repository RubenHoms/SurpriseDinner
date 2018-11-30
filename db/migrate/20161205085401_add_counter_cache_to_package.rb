class AddCounterCacheToPackage < ActiveRecord::Migration
  def up
    add_column :packages, :package_deals_count, :integer, default: 0

    Package.reset_column_information
    Package.find_each do |p|
      Package.update_counters p.id, package_deals_count: p.package_deals.length
    end
  end

  def down
    remove_column :packages, :package_deals_count
  end
end
