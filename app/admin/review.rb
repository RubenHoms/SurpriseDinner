ActiveAdmin.register Review do
  permit_params :quote, :image, :featured, :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :quote
      f.input :featured
      f.input :image, as: :file,
                      hint: (image_tag(f.object.image) if f.object.image.file?)
    end
    f.actions
  end
end
