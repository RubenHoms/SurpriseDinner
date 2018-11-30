class RemoveEmailFromRestaurants < ActiveRecord::Migration
  def up
    remove_column :restaurants, :email
  end

  def down
    add_column :restaurants, :email, :string
  end
end
