class AddDescriptionToPackage < ActiveRecord::Migration
  def up
    add_column :packages, :description, :text
  end

  def down
    remove_column :packages, :description
  end
end
