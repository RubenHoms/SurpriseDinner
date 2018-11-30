context.instance_eval do
  f.inputs 'Adresgegevens', for: [:address, f.object.address] do |s|
    s.input :street
    s.input :street_number
    s.input :zip_code
    s.input :city
    s.input :country, prioritized_countries: ['NL']
    s.input :telephone
    s.input :email, as: :email
  end
end