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
require 'sidekiq/testing'
require 'mandrill'

describe Booking do
  subject(:booking) { FactoryGirl.create(:booking) }
  let(:invalid_booking_email) { FactoryGirl.build(:invalid_booking_email) }
  let(:invalid_booking_persons) { FactoryGirl.build(:invalid_booking_persons) }
  let(:invalid_booking_telephone) { FactoryGirl.build(:invalid_booking_telephone) }
  let(:booking_step_wat_en_wie) { FactoryGirl.create(:booking_step_wat_en_wie) }
  let(:booking_step_contactgegevens) { FactoryGirl.create(:booking_step_contactgegevens) }

  describe 'scopes' do
    describe '#uncompleted' do
      let(:uncompleted_booking_nil_status) { FactoryGirl.create(:booking, status: nil) }
      it 'should return all uncompleted bookings' do
        expect(Booking.uncompleted).to include(booking_step_wat_en_wie)
        expect(Booking.uncompleted).to include(booking_step_contactgegevens)
        expect(Booking.uncompleted).to include(uncompleted_booking_nil_status)
      end
      it 'should not include completed bookings' do
        expect(Booking.uncompleted).to_not include(booking)
      end
    end
  end
  describe '#generate_token' do
    before do
      allow(SecureRandom).to receive(:urlsafe_base64)
        .and_return('generated_token')
    end

    it 'has a generated token on creation' do
      expect(booking.token).to eq 'generated_token'
    end
  end

  describe '#create_code' do
    let(:uncomplete_booking) { create(:booking, status: Booking.wizard_steps.last) }
    let(:complete_booking) { create(:booking, status: Booking::COMPLETE_STATUS) }

    it 'should not create a code if the booking is uncomplete' do
      expect(uncomplete_booking.code).to be_nil
    end

    it 'should have a code if the booking is complete' do
      expect(complete_booking.code).to_not be_nil
    end
  end

  describe '#create' do
    it 'has a valid factory' do
      expect(booking).to be_valid
    end

    context 'validations' do
      it 'should have persons and a package' do
        expect(booking.total_price).not_to be_nil
        expect(booking.persons).not_to be_nil
        expect(booking.package.price).not_to be_nil
      end

      it 'should have a valid email' do
        expect(invalid_booking_email).not_to be_valid
      end

      it 'should have some persons' do
        expect(invalid_booking_persons).not_to be_valid
      end

      it 'should have a valid phone number' do
        expect(invalid_booking_telephone).not_to be_valid
      end
    end
  end

  describe '#total_price' do
    it 'returns the correct total price' do
      expected_price = booking.persons * booking.package.price
      expect(booking.total_price).to eq expected_price
    end
  end

  describe '#time' do
    before { subject.update_columns(at: Time.zone.parse('17:00')) }

    it 'returns correctly formatted' do
      expect(subject.time).to eq '17:00'
    end
  end

  describe '#date' do
    before { subject.update_columns(at: '1 October 2016'.to_date) }

    it 'returns correctly formatted' do
      expect(subject.date).to eq 'zaterdag 1 oktober 2016'
    end
  end

  describe '#paid?' do
    it 'should not be paid if there are no paid payment objects' do
      expect(subject.paid?).to be false
    end

    context 'charged back payments' do
      let(:charged_back_booking) { create(:charged_back_booking) }
      let(:charged_back_and_paid_booking) { create(:charged_back_and_paid_booking) }

      it 'should not be paid if the payment is charged back' do
        expect(charged_back_booking.paid?).to be false
      end

      it 'should be paid if there is a charged back and a paid payment' do
        expect(charged_back_and_paid_booking.paid?).to be true
      end
    end
  end

  describe '#activated?' do
    subject { booking.activated? }

    let(:booking) { build(:booking, code: code) }
    let(:code) { build(:code, activated_at: activated_at) }

    context 'when the booking is activated' do
      let(:activated_at) { Time.now }

      it { is_expected.to be true }
    end

    context 'when the booking is not activated' do
      let(:activated_at) { nil }

      it { is_expected.to be false }
    end
  end

  describe '#previous_bookings' do
    let(:previous_booking_same_email) { create(:booking, email: booking.email) }
    let(:previous_booking_same_telephone) { create(:booking, telephone: booking.telephone) }

    it 'should return bookings with the same email' do
      expect(booking.previous_bookings).to include previous_booking_same_email
    end

    it 'should return bookings with the same telephone' do
      expect(booking.previous_bookings).to include previous_booking_same_telephone
    end

    it 'should not return self' do
      expect(booking.previous_bookings).not_to include booking
    end
  end

  describe '#handle_activation_mail' do
    before do
      allow_any_instance_of(SendMeetingPointSmsJob)
        .to receive(:perform).and_return(true)
      allow_any_instance_of(ChargeBackBookingJob)
        .to receive(:perform).and_return(true)
      allow_any_instance_of(Mandrill::API)
        .to receive_message_chain(:templates, :render, '[]').and_return('')
      ENV["SMTP_PASSWORD"] = 'fake_api_key'

      Sidekiq::Testing.inline!
      ActionMailer::Base.deliveries.clear
    end

    context 'when the booking is not completed' do
      it 'wont sent a mail' do
        expect { booking.update(restaurant: build(:restaurant)) }
          .to_not change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'when the booking is completed' do
      context 'when the booking does not have a restaurant yet' do
        let(:booking) { create(:booking, restaurant: nil) }

        it 'does sent a mail' do
          expect { booking.update(restaurant: build(:restaurant)) }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'has sent to the given email' do
          booking.update(restaurant: build(:restaurant))
          expect(ActionMailer::Base.deliveries.first.to)
            .to contain_exactly(booking.email)
        end
      end

      context 'when the booking already has a restaurant assigned' do
        let(:booking) { create(:booking, restaurant: build(:restaurant)) }

        it 'wont sent a mail' do
          expect { booking.update(restaurant: build(:restaurant)) }
            .to_not change { ActionMailer::Base.deliveries.count }
        end
      end

      context 'when there is not a restaurant being assigned' do
        it 'wont sent a mail' do
          expect { booking.update(persons: 2) }
            .to_not change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end

  describe '#reschedule_booking!' do
    let!(:booking) { FactoryGirl.create(:booking) }
    before do
      allow_any_instance_of(Mandrill::API)
          .to receive_message_chain(:templates, :render, '[]').and_return('')
      allow_any_instance_of(SendMeetingPointSmsJob)
          .to receive(:perform).and_return true
      allow_any_instance_of(BookingMailerJob)
          .to receive(:perform).and_return true
      allow_any_instance_of(ScheduledJob).to receive_message_chain(:job, :delete) { true }
      Sidekiq::Testing.inline!
      FactoryGirl.create(:scheduled_job, job_name: 'SendMeetingPointSmsJob', schedulable: booking)
      FactoryGirl.create(:scheduled_job, job_name: 'BookingMailerJob', schedulable: booking)

      ActionMailer::Base.deliveries.clear
    end

    context 'date updated' do
      it 'should send an email with an update' do
        expect { booking.update(at: DateTime.now) }
          .to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'time updated' do
      it 'should send an email with an update' do
        expect { booking.update(at: DateTime.now) }
          .to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'uncompleted booking' do
      let!(:booking) { FactoryGirl.create(:booking_step_wat_en_wie) }
      context 'date updated' do
        it 'should not send an email with an update' do
          expect { booking.update(date: DateTime.now) }
              .to_not change { ActionMailer::Base.deliveries.count }
        end
      end

      context 'time updated' do
        it 'should not send an email with an update' do
          expect { booking.update(time: DateTime.now) }
              .to_not change { ActionMailer::Base.deliveries.count }
        end
      end
    end

    context 'booking that has no scheduled jobs' do
      it 'should schedule new jobs' do
        booking.scheduled_jobs.destroy_all
        expect{booking.update(at: DateTime.now)}.to change{ booking.reload.scheduled_jobs.size }.from(0).to(2)
      end
    end
  end

  describe '#set_booking_slug' do
    let(:city) { FactoryGirl.create(:city, name: 'groningen') }
    subject(:booking) { build(:booking, name: 'Jan Jansen', at: '2017-01-26', city: city) }

    context 'when the booking is completed' do
      before { booking.status = 'completed' }

      it 'correctly sets the booking slug' do
        expect { subject.save }.to change { subject.slug }
          .to('jan-jansen-gaat-op-26-januari-uit-eten-in-groningen')
      end
    end

    context 'when the booking is not completed' do
      before { booking.status = nil }

      it 'correctly sets the booking slug' do
        expect { subject.save }.to_not change { subject.slug }
      end
    end

    context 'when the booking is completed and the slug is already set' do
      before { booking.update(status: 'completed') }

      it 'should not override the booking slug' do
        expect { subject.save }.to_not change { subject.slug }
      end
    end
  end

  describe '#profit' do
    let!(:restaurant) { FactoryGirl.create(:restaurant) }
    let!(:package) { FactoryGirl.create(:package, price: 50) }
    let!(:package_deal) { FactoryGirl.create(:package_deal, package: package, restaurant: restaurant, price: 40) }
    let!(:booking) { FactoryGirl.create(:booking, restaurant: restaurant, package: package, persons: 5) }

    context 'when there is no restaurant selected yet' do
      before { booking.restaurant = nil }

      it 'should return 0' do
        expect(booking.profit).to be_zero
      end
    end

    context 'when a restaurant is selected' do
      let(:expected_profit) do
        booking.total_price - (booking.persons * package_deal.price)
      end

      it 'should calculate the profit' do
        expect(booking.profit).to eq expected_profit
      end
    end
  end
end
