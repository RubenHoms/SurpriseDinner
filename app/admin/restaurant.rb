ActiveAdmin.register Restaurant do
  config.sort_order = 'id_asc'
  permit_params :name, :meeting_point_id, :image, :iban, :bic,
                address_attributes: [:id, :street, :street_number, :city,
                                     :country, :zip_code, :telephone, :email],
                package_deals_attributes: [:_destroy, :id, :price, :package_id]

  filter :name, label: 'Naam'
  filter :iban, label: 'IBAN'
  filter :bic, label: 'BIC'
  filter :address_city, label: 'Stad', as: :select, collection: -> { Restaurant.all.includes(:address).pluck(:city).uniq }
  filter :packages_name, label: 'Thema', as: :select, collection: -> { Package.all.map(&:name) }

  show do
    render 'show', context: self
  end

  index do
    id_column
    column :name
    column :city
    column :meeting_point
    column :number_of_packages
    actions
  end

  form do |f|
    render 'form', f: f, context: self
  end

  controller do
    def scoped_collection
      super.includes(:address, :meeting_point)
    end

    def new
      @restaurant = Restaurant.new
      @restaurant.build_address
    end
  end
end