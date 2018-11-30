context.instance_eval do
  tabs do
    tab 'Coupon' do
      attributes_table do
        row :code
        row :discount_percentage
        row :expires_at
      end
    end

    tab 'Gebruikte coupons' do
      table_for coupon.bookings.completed do |booking|
        column(:name) {|booking| booking.name }
        column(:created_at) { |booking| booking.created_at }
        column(:korting) { |booking| booking.coupon_redemption.discount }
      end
    end
  end
end