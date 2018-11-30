# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  booking_id         :integer
#  mollie_payment_id  :string
#  mollie_payment_url :string
#  token              :string
#  payment_status     :string
#  paid_at            :datetime
#  amount_cents       :integer          default(0), not null
#  amount_currency    :string           default("EUR"), not null
#

require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  before do
    stub_request(:any, %r{https://api.mollie.nl/v1/payments})
      .to_return(body: mollie_body)

    request.env['HTTP_REFERER'] = booking_build_path(
      booking_token: booking.token, id: :afronden
    )
  end

  let(:booking) { create(:booking) }
  let(:mollie_body) do
    {
      id: 't_12345',
      payment_url: 'https://www.mollie.com/payscreen/select-method/',
      status: mollie_status
    }.to_json
  end
  let(:mollie_status) { 'paid' }

  describe '#new' do
    def new_payment
      get :new, booking_token: booking_token
    end

    let(:booking_token) { booking.token }

    it 'creates a new payment object' do
      expect { new_payment }.to change { Payment.count }.by(1)
    end

    it 'redirects to the mollie page' do
      new_payment
      expect(response).to redirect_to Payment.last.mollie_payment_url
    end

    context 'when the booking already has a payment object' do
      before { create(:payment, booking: booking, payment_status: status) }

      context 'when the booking is open' do
        let(:status) { 'open' }

        it 'does create a new payment object' do
          expect { new_payment }.to change { Payment.count }.by(1)
        end

        it 'redirects to Mollie' do
          new_payment
          expect(response).to redirect_to Payment.last.mollie_payment_url
        end
      end

      context 'when the booking is paid' do
        let(:status) { 'paid' }

        it 'wont create a new payment object' do
          expect { new_payment }.to_not change { Payment.count }
        end

        it 'renders an error' do
          new_payment
          expect(flash[:alert]).to include I18n.t('payments.new.alert')
        end

        it 'wont redirect to Mollie' do
          new_payment
          expect(response).to_not redirect_to Payment.last.mollie_payment_url
        end
      end
    end

    context 'when an invalid booking is passed' do
      let(:booking_token) { 'wrong_token' }

      it 'wont create a new payment object' do
        expect { new_payment }.to_not change { Payment.count }
      end

      it 'renders an error' do
        new_payment
        expect(flash[:alert]).to include I18n.t('payments.new.alert')
      end

      it 'redirects to the homepage' do
        new_payment
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#show' do
    def show_payment
      get :show, booking_token: booking.token
    end

    context 'paid payment' do

      it 'should show the success page' do
        create(:paid_payment, booking: booking)
        show_payment
        expect(response).not_to redirect_to booking_build_path(booking_token: booking.token, id: :afronden)
      end
    end

    context 'unpaid payments' do
      %w(open cancelled pending expired failed refunded charged_back).each do |status|
        context "#{status} payment" do
          let(:mollie_status) { status }
          before do
            create(:payment, payment_status: status, booking: booking)
            show_payment
          end

          it 'should redirect to the booking form' do
            expect(response).to redirect_to booking_build_path(booking_token: booking.token, id: :afronden)
            expect(flash[:alert]).to include I18n.t("payments.show.status.#{status}")
          end
        end
      end
    end
  end
end
