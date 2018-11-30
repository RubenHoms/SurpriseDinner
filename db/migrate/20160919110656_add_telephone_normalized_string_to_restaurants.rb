class AddTelephoneNormalizedStringToRestaurants < ActiveRecord::Migration
  def up
    add_column :restaurants, :telephone_normalized, :string
  end

  def down
    remove_column :restaurants, :telephone_normalized
  end
end
