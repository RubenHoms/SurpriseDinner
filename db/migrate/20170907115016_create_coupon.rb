class CreateCoupon < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code, index: true
      t.integer :discount_percentage
      t.date :expires_at
    end
  end
end
