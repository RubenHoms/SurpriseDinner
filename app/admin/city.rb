ActiveAdmin.register City do
  config.sort_order = 'id_asc'
  permit_params :name

  filter :name

  index do
    id_column
    column :name
    actions
  end

  form do |f|
    render 'form', f: f, context: self
  end

  show do
    render 'show', context: self
  end
end
