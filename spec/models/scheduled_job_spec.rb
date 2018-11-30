# == Schema Information
#
# Table name: scheduled_jobs
#
#  id               :integer          not null, primary key
#  job_id           :string
#  job_name         :string
#  at               :datetime
#  args             :json
#  schedulable_id   :integer
#  schedulable_type :string
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'
require 'sidekiq/testing'

describe ScheduledJob do
  let(:job_name) { 'CompleteBookingJob' }
  let(:scheduled_job) { FactoryGirl.create(:scheduled_job, job_name: job_name) }

  before do
    Sidekiq::Testing.fake!
    allow_any_instance_of(job_name.constantize)
        .to receive(:perform).and_return(true)
  end

  it 'has a valid factory' do
    expect(scheduled_job).to be_valid
  end

  context 'validations' do
    %w(job_name at args).each do |field|
      it "should have #{field}" do
        scheduled_job.send("#{field}=", nil)
        expect(scheduled_job).to_not be_valid
      end
    end

    it 'can not have a job name that does not exist' do
      expect { scheduled_job.job_name = 'FakeJob' }.to change{ scheduled_job.valid? }.from(true).to(false)
    end
  end

  context 'public methods' do
    it '#job_class returns the job class' do
      expect(scheduled_job.job_class).to eq job_name.constantize
    end

    it '#start_job pushes the job to the scheduled set' do
      expect{ scheduled_job }.to change{ job_name.constantize.jobs.size }.by(1)
    end

    it '#start_job raises an exception if it can not start a job' do
      allow_any_instance_of(ScheduledJob).to receive(:job_id=).and_return('')
      expect{scheduled_job.start_job}.to raise_error(Exceptions::JobStartError)
    end

    it '#cancel raises an exception if it can not cancel a job' do
      allow(scheduled_job).to receive_message_chain(:job, :delete) { false }
      expect{scheduled_job.cancel}.to raise_error(Exceptions::JobCancelError)
    end
  end

  context 'callbacks' do
    context '#reschedule' do
      before do
        allow_any_instance_of(ScheduledJob).to receive(:cancel) { scheduled_job.job_class.jobs.pop }
      end

      it 'should reschedule the job if at has changed' do
        old_time = scheduled_job.at.to_datetime
        new_time = old_time + 1.day
        expect{ scheduled_job.update_attribute(:at, scheduled_job.at + 1.day) }.
            to change{ Time.at(scheduled_job.job_class.jobs.last['at']).to_datetime }.
                from(old_time).to(new_time)
      end

      it 'should have only one job scheduled' do
        expect{ scheduled_job.update_attribute(:at, scheduled_job.at + 1.day) }.to_not change{ scheduled_job.job_class.jobs.size }
      end
    end
  end
end
