class AddImageToPackages < ActiveRecord::Migration
  def up
    add_attachment :packages, :image
  end

  def down
    remove_attachment :packages, :image
  end
end
