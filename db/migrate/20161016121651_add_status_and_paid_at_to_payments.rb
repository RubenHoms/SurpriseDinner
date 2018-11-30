class AddStatusAndPaidAtToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payment_status, :string
    add_column :payments, :paid_at, :datetime
  end
end
