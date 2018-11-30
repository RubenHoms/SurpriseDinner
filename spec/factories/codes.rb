# == Schema Information
#
# Table name: codes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  activated_at :datetime
#  booking_id   :integer
#

FactoryGirl.define do
  factory :code do
    activated_at nil
  end
end