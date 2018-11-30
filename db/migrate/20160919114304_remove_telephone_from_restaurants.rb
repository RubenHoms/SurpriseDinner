class RemoveTelephoneFromRestaurants < ActiveRecord::Migration
  def up
    remove_columns :restaurants, :telephone, :telephone_normalized
  end

  def down
    add_column :restaurants, :telephone, :string
    add_column :restaurants, :telephone_normalized, :string
  end
end
