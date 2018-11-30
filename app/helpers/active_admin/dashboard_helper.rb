module ActiveAdmin
  module DashboardHelper
    def i18n_context(key, *args)
      I18n.t("active_admin.dashboard_content.#{key}", *args)
    end

    def profit_in_month(month = 0.months.ago)
      bookings_in(month).each_with_object({}) do |booking, res|
        key = booking.at.to_date
        profit = booking.total_price.to_f
        res[key] = res[key] ? res[key] + profit : profit
      end
    end

    def bookings_in_previous_month
      (1.month.ago.to_date..Date.today).to_a.each_with_object({}) do |date, res|
        res[date] = Booking.on_date(date).completed.count
      end
    end

    def profit_per_month
      (0..5).to_a.reverse.each_with_object({}) do |amount_of, res|
        key = I18n.l(amount_of.months.ago, format: '%B').capitalize
        profit = profit_in_month(amount_of.months.ago)
        res[key] = profit.inject(0) do |memo, day|
          memo + day.last
        end
      end
    end

    def best_selling_packages
      Package.all.includes(:bookings).each_with_object({}) do |package, res|
        res[package.name] = package.bookings.completed.count
      end
    end

    def bookings_per_city
      Booking.includes(:city).completed.each_with_object({}) do |booking, res|
        key = booking.city.name
        res[key] = res[key] ? res[key] + 1 : 1
      end
    end

    def restaurants_per_city
      Restaurant.includes(:address).all.each_with_object({}) do |restaurant, res|
        res[restaurant.city] = res[restaurant.city] ? res[restaurant.city] + 1 : 1
      end
    end

    def profit_per_city
      Booking.includes(:city).completed.each_with_object({}) do |booking, res|
        key = booking.city.name
        profit = booking.total_price.to_f
        res[key] = res[key] ? res[key] + profit : profit
      end
    end

    def booking_description(booking)
      i18n_context(
        'today.booking_description',
        name: booking.name,
        time: booking.time,
        persons: booking.persons,
        restaurant: booking.restaurant.try(:name) || '...',
        city: booking.city.name
      )
    end

    private

    def bookings_in(month)
      Booking.completed.in_month(month)
    end
  end
end