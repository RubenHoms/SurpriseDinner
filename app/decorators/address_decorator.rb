class AddressDecorator < Draper::Decorator
  STATIC_MAP_IMAGE_SIZE = '1000x1000'.freeze

  decorates :address
  delegate_all

  def readable
    "#{object.street} #{object.street_number}"
  end

  def static_map_image_url
    [
      'http://maps.googleapis.com/maps/api/staticmap?center=',
      map_image_address,
      "&size=#{STATIC_MAP_IMAGE_SIZE}",
      "&key=#{Rails.application.secrets.google_api_key}",
      '&zoom=13&scale=2&maptype=roadmap&format=png&visual_refresh=true'
    ].join
  end

  def maps_url
    "http://maps.google.com/maps?daddr=#{map_image_address}"
  end

  private

  def map_image_address
    object.full_address.tr(' ', '+')
  end
end
