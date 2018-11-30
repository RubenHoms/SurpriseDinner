# == Schema Information
#
# Table name: cities
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime
#  updated_at    :datetime
#  bookable_from :datetime
#

FactoryGirl.define do
  factory :city do
    name FFaker::Address.city
  end
end
