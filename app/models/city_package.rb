# == Schema Information
#
# Table name: city_packages
#
#  id         :integer          not null, primary key
#  package_id :integer
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class CityPackage < ActiveRecord::Base
  belongs_to :city
  belongs_to :package
end
