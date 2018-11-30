context.instance_eval do
  f.inputs 'Boeking details' do
    f.input :name
    f.input :date, as: :string, input_html: { class: 'form-control datepicker' }
    f.input :time, as: :string
    f.input :persons, as: :select, collection: (0..200).to_a
    f.input :telephone
    f.input :email
    f.input :city, as: :select, collection: city_select_values
    f.input :notes
  end

  f.inputs 'Thema' do
    f.input :package
  end

  actions
end