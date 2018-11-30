# == Schema Information
#
# Table name: settlement_batches
#
#  id         :integer          not null, primary key
#  name       :string
#  settled_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  xml        :text
#

FactoryGirl.define do
  factory :settlement_batch do
    name Date.today.to_s

    factory :settlement_batch_settled do
      settled_at DateTime.now
    end
  end
end
