require 'rails_helper'

RSpec.describe Bookings::BuildController, type: :controller do
  describe '#show' do
    let(:package) { create(:package) }
    let(:city) { create(:city, packages: [package]) }
    let(:booking) { create(:booking, city: city) }
    let(:booking_token) { booking.token }

    before { get :show, booking_token: booking_token, id: 'afronden' }

    context 'when passing a non-existing booking' do
      let(:booking_token) { 'invalid' }

      it 'redirects to the homepage' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when passing an open booking' do
      it 'does not redirect to the homepage' do
        expect(response).to_not be_redirect
      end
    end

    context 'when passing a paid booking' do
      let(:booking) { create(:paid_booking) }

      it 'redirects to booking show page' do
        expect(response)
          .to redirect_to booking_payment_path(booking_token: booking.token)
      end
    end
  end
end
