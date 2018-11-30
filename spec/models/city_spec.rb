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

require 'rails_helper'

describe City do
  let(:city) { FactoryGirl.create(:city) }
  let(:booking) { FactoryGirl.create(:booking, city: city) }

  it { expect(city).to be_valid }

  describe '#bookable?' do
    subject { city.bookable? }

    let(:city) { build(:city, bookable_from: bookable_from) }

    context 'when bookable_from is nil' do
      let(:bookable_from) { nil }

      it { is_expected.to be true }
    end

    context 'when bookable_from is in the past' do
      let(:bookable_from) { 1.day.ago }

      it { is_expected.to be true }
    end

    context 'when bookable_from is today' do
      let(:bookable_from) { Date.today }

      it { is_expected.to be true }
    end

    context 'when bookable_from is in the future' do
      let(:bookable_from) { 1.day.from_now }

      it { is_expected.to be false }
    end
  end
end
