class ChangePackagePriceToMoneyObject < ActiveRecord::Migration
  def change
    add_monetize :packages, :price
    migrate_old_price
    remove_column :packages, :price
  end

  def migrate_old_price
    Package.all.each do |p|
      p.update_column(:price_cents, p.price.cents * 100)
    end
  end
end
