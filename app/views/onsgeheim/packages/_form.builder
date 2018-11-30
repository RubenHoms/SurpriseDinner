context.instance_eval do
  f.inputs 'Package details' do
    f.input :name
    f.input :price
    f.input :featured
    f.input :selling_points, as: :array
    f.input :image, as: :file
  end

  f.inputs 'Description' do
    f.input :description
  end

  f.inputs 'Steden' do
    f.input :cities, as: :check_boxes
  end

  actions
end