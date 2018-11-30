class AddIbanToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :iban, :string
  end
end
