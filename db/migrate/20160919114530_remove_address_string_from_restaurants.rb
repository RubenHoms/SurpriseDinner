class RemoveAddressStringFromRestaurants < ActiveRecord::Migration
  def up
    remove_column :restaurants, :address
  end

  def down
    add_column :restaurants, :address, :string
  end
end
