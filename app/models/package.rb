# == Schema Information
#
# Table name: packages
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string
#  featured            :boolean
#  selling_points      :string           default([]), is an Array
#  image_file_name     :string
#  image_content_type  :string
#  image_file_size     :integer
#  image_updated_at    :datetime
#  description         :text
#  package_deals_count :integer          default(0)
#  price_cents         :integer          default(0), not null
#  price_currency      :string           default("EUR"), not null
#

class Package < ActiveRecord::Base
  has_many :bookings
  has_many :package_deals, dependent: :destroy
  has_many :city_packages, dependent: :destroy
  has_many :cities, through: :city_packages

  before_save :remove_blank_selling_points

  has_attached_file :image,
                    styles: { normal: '400x260#', square: '400x400#', original: '1000x1000>' },
                    processors: [:thumbnail, :paperclip_optimizer]

  FEATURE_LIMIT = 3
  SELLING_POINTS_MINIMUM = 1
  SELLING_POINTS_LIMIT = 5

  scope :featured, -> { where(featured: true).limit(FEATURE_LIMIT).order(:price_cents) }

  monetize :price_cents
  validates_attachment :image, content_type: {
    content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
  }
  validate :feature_limit_reached
  validate :selling_point_limits

  private

  def feature_limit_reached
    featured_items = Package.where(featured: true).count
    featured_items += 1 if featured?
    if featured_items > FEATURE_LIMIT
      errors.add(:featured, "limit (#{FEATURE_LIMIT}) reached.")
    end
  end

  def selling_point_limits
    if selling_points.size > SELLING_POINTS_LIMIT || selling_points.size < SELLING_POINTS_MINIMUM
      errors.add(:selling_points, "limit (min #{SELLING_POINTS_MINIMUM}, max #{SELLING_POINTS_LIMIT}) reached.")
    end
  end

  def remove_blank_selling_points
    selling_points.reject!(&:blank?)
  end
end
