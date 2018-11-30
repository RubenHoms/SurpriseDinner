class HomeController < ApplicationController
  layout 'home'

  def index
    @packages = Package.featured
    @reviews = Review.featured
  end
end
