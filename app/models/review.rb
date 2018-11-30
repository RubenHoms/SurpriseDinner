# == Schema Information
#
# Table name: reviews
#
#  id                 :integer          not null, primary key
#  quote              :text
#  name               :string
#  featured           :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Review < ActiveRecord::Base
  FEATURE_LIMIT = 5

  scope :featured, -> { where(featured: true).limit(FEATURE_LIMIT) }

  has_attached_file :image,
                    styles: { original: '350x250#' },
                    processors: [:thumbnail, :paperclip_optimizer]

  validates :quote, presence: true
  validates_attachment :image, content_type: {
    content_type: ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']
  }
end
