class AddPaymentFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :mollie_payment_id, :string
    add_column :payments, :mollie_payment_url, :string
    add_column :payments, :token, :string
  end
end
