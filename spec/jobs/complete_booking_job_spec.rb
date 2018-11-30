require 'rails_helper'

describe CompleteBookingJob do
  describe '#perform' do
    def perform_job
      CompleteBookingJob.new.perform('booking_id' => booking.id)
    end

    before do
      allow_any_instance_of(CompleteBookingJob).to receive(:notify_slack).and_return(nil)
      stub_request(:post, /slack/).and_return(body: '')
    end

    context 'when the status is not completed' do
      let(:booking) { create(:booking, status: nil) }

      it 'correctly sets the status' do
        expect { perform_job }.to change { booking.reload.status }.to('completed')
      end

      it 'correctly sets the slug' do
        expect { perform_job }.to change { booking.reload.slug }.from(nil)
      end

      it 'notifies slack' do
        expect_any_instance_of(CompleteBookingJob).to receive(:notify_slack).once
        perform_job
      end
    end

    context 'when the status is completed' do
      let(:booking) { create(:booking, status: 'completed') }

      it 'does not change status' do
        expect { perform_job }.to_not change { booking.reload.status }.from('completed')
      end

      it 'does not change the slug' do
        expect { perform_job }.to_not change { booking.reload.slug }.from(booking.slug)
      end

      it 'does not notify slack' do
        expect_any_instance_of(CompleteBookingJob).to_not receive(:notify_slack)
        perform_job
      end
    end
  end
end
