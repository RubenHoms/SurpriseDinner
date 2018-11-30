# == Schema Information
#
# Table name: bookings
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  telephone            :string
#  email                :string
#  restaurant_id        :integer
#  package_id           :integer
#  persons              :integer
#  telephone_normalized :string
#  notes                :text
#  name                 :string
#  status               :string
#  token                :string           not null
#  notified_at          :datetime
#  at                   :datetime
#  personal_message     :text
#  slug                 :string
#  city_id              :integer
#

require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  before do
    allow(SecureRandom).to receive(:urlsafe_base64)
      .and_return('generated_token')
  end

  describe '#create' do
    before do
      request.env['HTTP_REFERER'] = root_path
      post :create, params
    end

    context 'with city' do
      let(:city) { City.create(name: 'Groningen') }
      let(:params) { { city: city.id } }

      it 'gets redirected to the correct page' do
        expect(response).to redirect_to booking_build_path(
          'generated_token', Booking.wizard_steps.first)
      end
    end

    context 'without city' do
      let(:params) { { city: '' } }

      it 'gets redirected back' do
        expect(response).to redirect_to root_path
      end

      it 'has the correct flash message' do
        expect(flash[:error]).to include I18n.t('bookings.create.error')
      end
    end
  end

  describe '#show' do
    before { get :show, booking_slug: slug }

    let!(:booking) { create(:booking) }

    context 'with a correct booking slug' do
      let(:slug) { booking.slug }

      it 'does not redirects to the homepage' do
        expect(response).to_not redirect_to(root_path)
      end
    end

    context 'without a correct booking slug' do
      let(:slug) { 'ongeldige-boeking-slug' }

      it 'redirects to the homepage' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
