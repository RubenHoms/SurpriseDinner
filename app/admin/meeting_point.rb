ActiveAdmin.register MeetingPoint do
  config.sort_order = 'id_asc'
  permit_params :name, :description,
                address_attributes: [:id, :street, :street_number, :city, :country, :zip_code, :telephone, :email]

  filter :name
  filter :description
  filter :address_city, as: :select, collection: -> { MeetingPoint.all.includes(:address).map(&:city) }
  filter :restaurants_name, as: :string

  show do
    render 'show', context: self
  end

  form do |f|
    render 'form', f: f, context: self
  end

  controller do
    def new
      @meeting_point = MeetingPoint.new
      @meeting_point.build_address
    end
  end
end