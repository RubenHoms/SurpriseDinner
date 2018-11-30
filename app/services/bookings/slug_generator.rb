module Bookings
  class SlugGenerator
    delegate :at, :city, :name, to: :@booking

    def initialize(booking)
      @booking = booking
      @counter = 1
      @slug = generated_slug
    end

    def generate
      loop do
        break @slug unless Booking.exists?(slug: @slug)
        @slug = "#{generated_slug}-#{@counter}"
        @counter += 1
      end
    end

    private

    def generated_slug
      [name, 'gaat op', formatted_date, 'uit eten in', city.name].join(' ').parameterize
    end

    def formatted_date
      I18n.l(at, format: '%d %B')
    end
  end
end
