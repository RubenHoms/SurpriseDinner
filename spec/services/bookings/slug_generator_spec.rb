require 'rails_helper'

describe Bookings::SlugGenerator do
  subject { Bookings::SlugGenerator.new(booking) }

  let(:city) { FactoryGirl.create(:city, name: 'groningen') }
  let(:booking) { build(:booking, name: 'Jan Jansen', at: '2017-01-26', city: city) }

  describe '#generate' do
    context 'when the slug does not exist yet' do
      it 'correctly sets the booking slug' do
        expect(subject.generate).to eq('jan-jansen-gaat-op-26-januari-uit-eten-in-groningen')
      end
    end

    context 'when the slug already exists' do
      before { create(:booking, name: 'Jan Jansen', at: '2017-01-26', city: city) }

      it 'correctly sets the booking slug' do
        expect(subject.generate).to eq('jan-jansen-gaat-op-26-januari-uit-eten-in-groningen-1')
      end
    end
  end
end
