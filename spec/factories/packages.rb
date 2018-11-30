# == Schema Information
#
# Table name: packages
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string
#  featured            :boolean
#  selling_points      :string           default([]), is an Array
#  image_file_name     :string
#  image_content_type  :string
#  image_file_size     :integer
#  image_updated_at    :datetime
#  description         :text
#  package_deals_count :integer          default(0)
#  price_cents         :integer          default(0), not null
#  price_currency      :string           default("EUR"), not null
#

FactoryGirl.define do
  factory :package do
    name FFaker::Name.name
    price Random.rand(100).to_f
    selling_points ['foo', 'bar', 'baz']

    factory :featured_package do
      featured true
    end
  end
end
