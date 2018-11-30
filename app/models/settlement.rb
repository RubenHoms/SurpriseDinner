# == Schema Information
#
# Table name: settlements
#
#  id                    :integer          not null, primary key
#  booking_id            :integer
#  restaurant_id         :integer
#  settlement_batch_id   :integer
#  total_amount_cents    :integer          default(0), not null
#  total_amount_currency :string           default("EUR"), not null
#  created_at            :datetime
#  updated_at            :datetime
#

class Settlement < ActiveRecord::Base
  belongs_to :booking
  belongs_to :restaurant
  belongs_to :settlement_batch

  validates :booking, :restaurant, :settlement_batch, :total_amount, presence: true
  monetize :total_amount_cents, allow_nil: true, # Allow nil values so we can use standard presence validation
      numericality: { greater_than_or_equal_to: 0 }

  delegate :iban, :bic, :name, to: :restaurant, prefix: true, allow_nil: true
  delegate :token, to: :booking, prefix: true, allow_nil: true

  def self.from_booking(booking)
    deal = PackageDeal.find_by!(restaurant: booking.restaurant, package: booking.package)
    new(booking: booking, restaurant: booking.restaurant, total_amount: deal.price * booking.persons)
  end

  def to_transaction
    {
        name: restaurant_name,
        iban: restaurant_iban,
        bic: restaurant_bic,
        amount: total_amount.to_f,
        reference: booking_token,
        batch_booking: true
    }
  end
end
