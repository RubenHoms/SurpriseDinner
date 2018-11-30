require 'rails_helper'

describe 'bookings/show' do
  before do
    assign(:booking, booking)
    render
  end

  let(:booking) { create(:booking, code: code) }
  let(:code) { create(:code, activated_at: activated_at) }

  context 'when the booking is activated' do
    let(:activated_at) { Time.now }

    it 'has the correct title' do
      expect(rendered).to include(
        I18n.t(
          'bookings.show.title',
          name: booking.name,
          to: booking.restaurant.name,
          city: booking.restaurant.city
        )
      )
    end
  end

  context 'when the booking is not activated' do
    let(:activated_at) { nil }

    it 'has the correct title' do
      expect(rendered).to include(booking.name)
    end

    it 'does not show the restaurant name' do
      expect(rendered).to_not include(booking.restaurant.name)
    end
  end
end
