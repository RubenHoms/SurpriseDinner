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

FactoryGirl.define do
  factory :scheduled_job do
    job_id '12345'
    job_name 'CompleteBookingJob'
    at DateTime.now + 5.days
    args [1,2,3]
  end
end
