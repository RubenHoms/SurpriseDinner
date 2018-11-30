class ChangeAmountStringToFloat < ActiveRecord::Migration
  def change
    remove_column :payments, :amount
    add_column :payments, :amount, :float
  end
end
