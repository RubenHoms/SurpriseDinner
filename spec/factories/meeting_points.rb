# == Schema Information
#
# Table name: meeting_points
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#

FactoryGirl.define do
  factory :meeting_point do
    name FFaker::Name.name
    description FFaker::Lorem.phrase
    address

    factory :invalid_meeting_point_address do
      address nil
    end
  end
end
