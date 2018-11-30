class RemoveUnneededPaymentFields < ActiveRecord::Migration
  def change
    remove_column :payments, :persons, :integer
    remove_column :payments, :paid, :boolean
    remove_column :payments, :auth_result, :string
  end
end
