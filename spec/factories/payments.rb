# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  booking_id         :integer
#  mollie_payment_id  :string
#  mollie_payment_url :string
#  token              :string
#  payment_status     :string
#  paid_at            :datetime
#  amount_cents       :integer          default(0), not null
#  amount_currency    :string           default("EUR"), not null
#

FactoryGirl.define do
  factory :payment do
    amount 20.00
    payment_status 'open'

    factory :paid_payment do
      payment_status 'paid'
    end

    factory :charged_back_payment do
      payment_status 'charged_back'
    end
  end
end
