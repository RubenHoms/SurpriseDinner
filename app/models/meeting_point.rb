# == Schema Information
#
# Table name: meeting_points
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#

class MeetingPoint < ActiveRecord::Base
  has_many :restaurants, dependent: :restrict_with_error
  has_one :address, as: :addressable, dependent: :destroy

  delegate :full_address, :city, :latitude, :longitude, to: :address

  accepts_nested_attributes_for :address

  validates :address, presence: true
end
