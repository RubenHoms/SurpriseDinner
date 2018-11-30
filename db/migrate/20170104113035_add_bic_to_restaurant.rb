class AddBicToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :bic, :string, after: :iban
  end
end
