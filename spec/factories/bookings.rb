# == Schema Information
#
# Table name: bookings
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  telephone            :string
#  email                :string
#  restaurant_id        :integer
#  package_id           :integer
#  persons              :integer
#  telephone_normalized :string
#  notes                :text
#  name                 :string
#  status               :string
#  token                :string           not null
#  notified_at          :datetime
#  at                   :datetime
#  personal_message     :text
#  slug                 :string
#  city_id              :integer
#

FactoryGirl.define do
  factory :booking do
    name FFaker::Name.name
    telephone '0623427378'
    email FFaker::Internet.email
    persons Random.rand(1..99)
    at DateTime.tomorrow
    status Booking::COMPLETE_STATUS
    city

    # Associations
    restaurant
    package

    trait :without_restaurant do
      restaurant nil
    end

    factory :invalid_booking_email do
      email 'wrong'
    end

    factory :invalid_booking_persons do
      persons 0
    end

    factory :invalid_booking_telephone do
      telephone '0612345678901234567890'
    end

    factory :invalid_booking_time do
      time DateTime.yesterday
    end

    factory :booking_step_wat_en_wie do
      status 'wat_en_wie'
      name nil
      email nil
      telephone nil
    end

    factory :booking_step_contactgegevens do
      status 'contactgegevens'
    end

    factory :open_payment_booking do
      after(:create) do |booking|
        Payment.skip_callback(:create, :before, :mollie_api_create_payment)
        FactoryGirl.create(:payment, booking: booking, payment_status: 'open')
        Payment.set_callback(:create, :before, :mollie_api_create_payment)
      end
    end

    factory :paid_booking do
      after(:create) do |booking|
        Payment.skip_callback(:create, :before, :mollie_api_create_payment)
        FactoryGirl.create(:paid_payment, booking: booking)
        Payment.set_callback(:create, :before, :mollie_api_create_payment)
      end
    end

    factory :charged_back_booking do
      after(:create) do |booking|
        Payment.skip_callback(:create, :before, :mollie_api_create_payment)
        FactoryGirl.create(:charged_back_payment, booking: booking)
        Payment.set_callback(:create, :before, :mollie_api_create_payment)
      end
    end

    factory :charged_back_and_paid_booking do
      after(:create) do |booking|
        Payment.skip_callback(:create, :before, :mollie_api_create_payment)
        FactoryGirl.create(:charged_back_payment, booking: booking)
        FactoryGirl.create(:paid_payment, booking: booking)
        Payment.set_callback(:create, :before, :mollie_api_create_payment)
      end
    end
  end
end
