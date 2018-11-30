# == Schema Information
#
# Table name: restaurants
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  name               :string
#  meeting_point_id   :integer
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  number_of_packages :integer          default(0)
#  iban               :string
#  bic                :string
#

FactoryGirl.define do
  factory :restaurant do
    name FFaker::Name.name
    iban 'NL76TRIO0338417702'
    bic 'TRIONL2U'
    address
    meeting_point

    factory :invalid_restaurant_meeting_point do
      meeting_point nil
    end

    factory :invalid_restaurant_address do
      address nil
    end

    factory :restaurant_with_package do
      after(:create) do |restaurant|
        package = FactoryGirl.create(:package)
        FactoryGirl.create(:package_deal, restaurant: restaurant, package: package, price: package.price)
      end
    end
  end
end
