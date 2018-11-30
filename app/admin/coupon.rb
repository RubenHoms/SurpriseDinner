ActiveAdmin.register Coupon do
  config.sort_order = 'id_asc'
  permit_params :code, :discount_percentage, :expires_at

  filter :code

  index do
    id_column
    column :code
    column :discount_percentage
    column :expires_at
    actions
  end

  form do |f|
    render 'form', f: f, context: self
  end

  show do
    render 'show', context: self
  end
end
