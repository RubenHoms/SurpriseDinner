class CreateCouponRedemption < ActiveRecord::Migration
  def change
    create_table :coupon_redemptions do |t|
      t.belongs_to :booking
      t.belongs_to :coupon
    end

    add_index :coupon_redemptions, [:booking_id, :coupon_id]
  end
end
