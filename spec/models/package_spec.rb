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

require 'rails_helper'

describe Package do
  let(:package) { FactoryGirl.create(:package) }
  let(:featured_package) { FactoryGirl.create(:featured_package) }

  it 'has a valid factory' do
    expect(package).to be_valid
  end

  context 'validations' do
    it 'should not be able to add more featured package than the limit' do
      featured_package
      stub_const('Package::FEATURE_LIMIT', 1)
      extra_featured_package = FactoryGirl.build(:featured_package)
      expect(extra_featured_package).to be_invalid
    end

    it 'should not be able to add more selling points than the limit' do
      stub_const('Package::SELLING_POINTS_LIMIT', package.selling_points.size)
      package.selling_points << ['qux']
      expect(package).to be_invalid
    end

    it 'should at least have one selling point' do
      package.selling_points = []
      expect(package).to be_invalid
    end
  end

  context 'scopes' do
    it 'should return featured packages' do
      expect(Package.featured).to include featured_package
      expect(Package.featured).not_to include package
    end
  end

  describe 'selling points' do
    it 'should serialize it into an array' do
      expect(package.selling_points).to be_a Array
    end
  end
end
