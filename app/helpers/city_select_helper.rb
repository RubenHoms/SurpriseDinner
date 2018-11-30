module CitySelectHelper
  def city_select_values
    City.all.reject { |city| city.packages.count.zero? }.map { |city| [city.name, city.id] }
  end
end
