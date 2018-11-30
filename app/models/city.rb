# == Schema Information
#
# Table name: cities
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime
#  updated_at    :datetime
#  bookable_from :datetime
#

class City < ActiveRecord::Base
  has_many :bookings
  has_many :city_packages
  has_many :packages, through: :city_packages

  def bookable?
    bookable_from.nil? || bookable_from.past?
  end
end
