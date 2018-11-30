class PagesController < ApplicationController
  layout 'how_it_works', only: :how_it_works
  layout 'restaurant_info', only: :restaurant_info
end