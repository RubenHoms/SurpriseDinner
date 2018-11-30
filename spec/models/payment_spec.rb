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
require 'sidekiq/testing'
require 'mandrill'

describe Payment do
  before do
    Sidekiq::Testing.inline!
    allow_any_instance_of(SendMeetingPointSmsJob).to receive(:perform).and_return(true)
    allow_any_instance_of(ChargeBackBookingJob).to receive(:perform).and_return(true)
    allow_any_instance_of(CompleteBookingJob).to receive(:notify_slack).and_return(true)
    allow_any_instance_of(Mandrill::API).to receive_message_chain(:templates, :render, '[]').and_return('')

    WebMock.disable_net_connect!(allow: ['maps.googleapis.com'])
    stub_request(:any, 'https://api.mollie.nl/v1/payments')
      .to_return(body: mollie_body)
  end

  subject(:payment) { create(:payment, booking: booking) }

  let(:booking) { create(:booking) }
  let(:mollie_body) do
    {
      payment_url: 'https://www.mollie.com/payscreen/select-method/',
      status: mollie_status
    }.to_json
  end
  let(:mollie_status) { 'open' }

  describe '#create' do
    before do
      allow(SecureRandom).to receive(:urlsafe_base64)
        .and_return('generated_token')
    end

    it 'has a correct mollie_payment_url' do
      expect(payment.mollie_payment_url).to include 'https://www.mollie'
    end

    it 'has a token' do
      expect(payment.token).to eq 'generated_token'
    end

    context 'when a booking already has a payment' do
      before { subject }

      let(:new_payment) { build(:payment, booking: booking) }

      context 'when the last payment is open' do
        before { subject.update_attribute(:payment_status, 'open') }

        it 'can create a new payment' do
          expect(new_payment).to be_valid
        end
      end

      context 'when the last payment is paid' do
        before { subject.update_attribute(:payment_status, 'paid') }

        it 'cannot create a new payment' do
          expect(new_payment).to_not be_valid
        end
      end

      context 'when the last payment is charged back' do
        before { subject.update_attribute(:payment_status, 'charged_back') }

        it 'can create a new payment' do
          expect(new_payment).to be_valid
        end
      end
    end
  end

  describe '#handle_mollie_webhook_response' do
    it 'does an correct mollie API call' do
      subject.handle_mollie_webhook_response
      expect(a_request(:post, %r{https://api.mollie.nl/v1/payments}))
        .to have_been_made
    end

    context 'when having a new payment object' do
      it 'has open as default status' do
        expect(payment.payment_status).to eq 'open'
      end
    end

    context 'when the API status is paid' do
      let(:mollie_status) { 'paid' }

      it 'correctly sets the new status' do
        expect { subject.handle_mollie_webhook_response }
          .to change { subject.payment_status }.to 'paid'
      end

      it 'correctly update the paid_at attribute' do
        expect { subject.handle_mollie_webhook_response }
          .to change { subject.paid_at }.to be_within(10.seconds).of(Time.now)
      end
    end

    context 'when the API status is open' do
      it 'does not change the status' do
        expect { subject.handle_mollie_webhook_response }
          .to_not change { subject.payment_status }.from 'open'
      end

      it 'does not update the paid_at attribute' do
        expect { subject.handle_mollie_webhook_response }
          .to_not change { subject.paid_at }
      end
    end

    context 'when the API status is charged_back' do
      let(:mollie_status) { 'charged_back' }

      it 'correctly sets the new status' do
        expect { subject.handle_mollie_webhook_response }
            .to change { subject.payment_status }.to 'charged_back'
      end

      it 'does not update the paid_at attribute' do
        expect { subject.handle_mollie_webhook_response }
            .to_not change { subject.paid_at }
      end
    end

    context 'when the API status is something else' do
      it 'does not change the status' do
        expect { subject.handle_mollie_webhook_response }
          .to_not change { subject.payment_status }.from 'open'
      end

      it 'does not update the paid_at attribute' do
        expect { subject.handle_mollie_webhook_response }
          .to_not change { subject.paid_at }
      end
    end
  end

  describe '#update' do
    before { ActionMailer::Base.deliveries.clear }

    let(:mail_deliveries) { ActionMailer::Base.deliveries }
    let(:booking) { build(:booking_step_contactgegevens) }

    context 'when the booking changes to paid' do
      context 'when the booking is not completed yet' do
        it 'does send an email' do
          # Due to Sidekiq inline testing the feedback/personal page mail is sent as well as the confirmation mail
          expect { payment.update(payment_status: :paid) }
            .to change { ActionMailer::Base.deliveries.count }.by(3)
        end

        it 'has sent to the given email' do
          payment.update(payment_status: :paid)
          expect(ActionMailer::Base.deliveries.first.to)
            .to contain_exactly(booking.email)
        end
      end

      context 'when the booking is already completed' do
        before { booking.update_attribute :status, Booking::COMPLETE_STATUS }

        it 'does not send an email' do
          expect { payment.update_attribute(:payment_status, :paid) }
            .to_not change { ActionMailer::Base.deliveries.count }
        end
      end
    end

    context 'when the booking changes to cancelled' do
      before { payment.update(payment_status: :cancelled) }

      it 'has not sent an email' do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
