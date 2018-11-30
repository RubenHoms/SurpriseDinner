context.instance_eval do
  f.inputs 'FAQ item' do
    f.input :title
    f.input :published
  end

  f.inputs 'Inhoud' do
    f.input :content, input_html: { class: 'tinymce' }
    render 'partials/tinymce_init'
  end

  actions
end