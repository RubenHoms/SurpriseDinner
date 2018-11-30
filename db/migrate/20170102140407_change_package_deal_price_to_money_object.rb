class ChangePackageDealPriceToMoneyObject < ActiveRecord::Migration
  def change
    add_monetize :package_deals, :price
    migrate_old_price
    remove_column :package_deals, :price
  end

  def migrate_old_price
    PackageDeal.all.each do |p|
      p.update_column(:price_cents, p.price.cents * 100)
    end
  end
end
