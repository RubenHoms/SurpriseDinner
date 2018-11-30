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

class ScheduledJob < ActiveRecord::Base
  belongs_to :schedulable, polymorphic: true

  validate :valid_job
  validates :job_name, :at, :args, presence: true

  after_initialize :init
  before_create :start_job
  before_save :reschedule, if: :at_changed?, unless: :new_record?
  before_destroy :cancel, if: :job

  def self.find_job(id)
    scheduled_set.find_job id
  end

  def self.find_or_schedule!(schedulable, job_name, args, at)
    find_by(job_name: job_name, schedulable: schedulable) || create!(job_name: job_name,
                                                                     schedulable: schedulable,
                                                                     args: args,
                                                                     at: at)
  end

  def init
    self.at ||= DateTime.now
  end

  def job_class
    job_name.constantize
  end

  def job
    self.class.find_job job_id
  end

  def reschedule
    cancel
    start_job
  end

  def reschedule_at(datetime)
    update({at: datetime})
  end

  def cancel
    unless job.try(:delete)
      raise Exceptions::JobCancelError.new("Unable to cancel job #{job_name} for model #{schedulable.class}")
    end
  end

  private

  def self.scheduled_set
    Sidekiq::ScheduledSet.new
  end

  def start_job
    return if job
    self.job_id = job_class.perform_at(at, args)
    raise Exceptions::JobStartError.new("Unable to start job #{job_name} with args #{args}.") if self.job_id.blank?
  end

  def valid_job
    begin
      job_name.constantize
    rescue NameError
      errors.add(:job_name, "Unable to find job #{job_name}")
    end
  end
end
