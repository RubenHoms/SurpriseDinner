ActiveAdmin.register Faq do
  config.sort_order = 'id_asc'
  permit_params :title, :content, :published

  filter :title
  filter :content
  filter :published

  index do
    id_column
    column :title
    column :published
    actions
  end

  form do |f|
    render 'form', f: f, context: self
  end

  show do
    render 'show', context: self
  end
end
