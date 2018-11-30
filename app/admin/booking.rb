ActiveAdmin.register Booking do
  config.sort_order = 'id_asc'
  permit_params :name, :date, :time, :persons,
                :telephone, :email, :city_id, :notes,
                :restaurant_id, :package_id, :personal_message

  scope 'Voltooide boekingen', :completed, default: true
  scope 'Onvoltooide boekingen', :uncompleted
  scope 'Te verwerken boekingen', :to_be_processed
  scope 'Verwerkte boekingen', :processed

  filter :restaurant
  filter :created_at
  filter :telephone
  filter :email
  filter :persons
  filter :name
  filter :city
  filter :token
  filter :date

  index do
    id_column
    column :name
    column :at
    column :persons
    column :telephone
    column :email
    column :city
    column :notes
    column :restaurant
    column :package
    column {|booking| link_to 'Restaurant toewijzen', Rails.application.routes.url_helpers.assign_restaurant_onsgeheim_booking_url(booking) }
    actions
  end

  form do |f|
    render 'form', f: f, context: self
  end

  show do
    render 'show', context: self
  end

  before_create do |booking|
    booking.status = Booking.wizard_steps.last
  end

  controller do
    def scoped_collection
      super.includes(:restaurant, :package)
    end

    def find_resource
      Booking.find_by_token(params[:id]) || Booking.new
    end

    def new
      @booking = find_resource
      @suitable_restaurants = Restaurant.all
    end
  end

  member_action :request_payment do
    @booking = find_resource
    @booking.scheduled_jobs.create!(job_name: 'BookingMailerJob', args: {booking_id: @booking.id, template: 'request_payment'})
    redirect_to onsgeheim_booking_path(@booking, anchor: 'betalingsgegevens'), notice: 'Betalingsaanvraag verstuurd'
  end

  member_action :assign_restaurant do
    @booking = find_resource
    @suitable_restaurants = Restaurant.in_city(@booking.city.name.downcase)
                                      .with_package(@booking.package)
  end
end
