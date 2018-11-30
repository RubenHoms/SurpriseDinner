require 'rails_helper'

RSpec.describe ActivationsController, type: :controller do
  describe '#update' do
    def activate_code
      put :update, code: booking.code.code
    end

    context 'when the booking is valid to activate' do
      let(:booking) { create(:booking, status: 'completed') }

      it 'activates the code' do
        expect { activate_code }.to change { booking.reload.code.activated? }
          .to true
      end

      it 'doest not redirect to the homepage' do
        activate_code
        expect(response).to_not redirect_to root_path
      end
    end

    context 'when the booking misses a restaurant' do
      let(:booking) { create(:booking, status: 'completed', restaurant: nil) }

      it 'redirect to the homepage' do
        activate_code
        expect(response).to redirect_to root_path
      end

      it 'doesnt activate the code' do
        expect { activate_code }
          .to_not change { booking.reload.code.activated? }
      end
    end
  end
end
