require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe HooksController do
  let(:booking) { create(:booking) }

  describe '#sms_status_report' do
    let!(:sms_send_error_params) { { errorcode: 5, errordescription: 'Test', statuscode: 1, reference: booking.id, to: booking.telephone_normalized } }
    let!(:sms_send_correct_params) { { errorcode: '', errordescription: '', statuscode: 0, reference: booking.id, to: booking.telephone_normalized } }

    def faulty_sms_status_report_webhook
      get :sms_status_report, sms_send_error_params
    end

    def correct_sms_status_report_webhook
      get :sms_status_report, sms_send_correct_params
    end

    it 'uses the fallback mechanism to notify of errors in sending SMS' do
      faulty_sms_status_report_webhook
      expect(booking.reload.notified_at).to be_nil
    end

    it 'sets the booking as notified when we get a correct webhook' do
      correct_sms_status_report_webhook
      expect(booking.reload.notified_at).to_not be_nil
    end
  end

  context '#mollie_webhook' do
    let(:booking) { create(:open_payment_booking) }
    let(:payment) { booking.payments.last }

    def mock_mollie_response(status)
      allow_any_instance_of(Payment)
        .to receive(:mollie_get_payment) { OpenStruct.new(status: status) }
    end

    def payment_webhook
      get :mollie_webhook, { id: payment.mollie_payment_id }
    end

    it 'should update all received status' do
      Payment::MOLLIE_PAYMENT_STATUSES.each do |status|
        mock_mollie_response(status)
        payment_webhook
        expect(payment.reload.payment_status).to eq status
      end
    end

    it 'should return an empty response' do
      mock_mollie_response('paid')
      payment_webhook
      expect(response.body).to be_empty
    end

    context 'wrong mollie payment id' do
      before { allow_any_instance_of(Payment).to receive(:mollie_payment_id) { 'tr_404' } }

      it 'should return 404' do
        payment_webhook
        expect(response.status).to eq 404
      end
    end
  end
end
