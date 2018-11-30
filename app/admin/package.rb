ActiveAdmin.register Package do
  config.sort_order = 'id_asc'
  permit_params :name, :price, :featured, :image_file_name,
                :image, :image_content_type, :image_file_size,
                :image_updated_at, :description,
                selling_points: [], city_ids: []

  filter :name
  filter :price
  filter :featured

  index do
    id_column
    column :name
    column :price
    column :featured
    column :description do |package|
      truncate(package.description, seperator: ' ', escape: false)
    end
    column :steden do |package|
      package.cities.count
    end
    actions
  end

  form do |f|
    render 'form', f: f, context: self
  end

  show do
    render 'show', context: self
  end
end
