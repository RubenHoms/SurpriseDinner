class AddSellingPointsToPackages < ActiveRecord::Migration
  def up
    add_column :packages, :selling_points, :string, array: true, default: []
  end

  def down
    remove_column :packages, :selling_points
  end
end
