class ChangePaymentAmountToMoneyObject < ActiveRecord::Migration
  def change
    add_monetize :payments, :amount
    migrate_old_amount
    remove_column :payments, :amount
  end

  def migrate_old_amount
    Payment.all.each do |p|
      p.update_column(:amount_cents, p.amount * 100)
    end
  end
end
