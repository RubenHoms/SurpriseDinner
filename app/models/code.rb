# == Schema Information
#
# Table name: codes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  activated_at :datetime
#  booking_id   :integer
#

class Code < ActiveRecord::Base
  belongs_to :booking

  validates :code, length: { is: 6 }
  validates :code, uniqueness: true

  after_initialize :assign_code, unless: :code

  scope :unused, -> { where(activated_at: nil) }
  scope :used, -> { where.not(activated_at: nil) }

  def activate
    return if activated?
    self.activated_at = DateTime.now
    save!
  end

  def activated?
    !activated_at.nil?
  end

  private

  # TODO: Find a way to clean up old codes when all the codes have been used up (far future)
  def assign_code
    new_code = create_code
    assign_code if Code.exists?(code: new_code)
    self.code ||= new_code
  end

  def create_code
    SecureRandom.hex(3).upcase
  end
end
