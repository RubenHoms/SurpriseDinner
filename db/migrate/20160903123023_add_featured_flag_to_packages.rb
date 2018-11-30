class AddFeaturedFlagToPackages < ActiveRecord::Migration
  def up
    add_column :packages, :featured, :boolean
  end

  def down
    remove_column :packages, :featured
  end
end
