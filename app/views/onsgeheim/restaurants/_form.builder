context.instance_eval do
  f.inputs 'Restaurant details' do
    f.input :name
    f.input :image, as: :file
    f.input :meeting_point_id, label: 'Meeting Point', as: :select, collection: MeetingPoint.all.map{|mp| [mp.name, mp.id]}
  end

  panel 'Bankgegevens' do
    f.inputs do
      f.input :iban
      f.input :bic
    end
  end

  panel 'Thema afspraken' do
    f.inputs do
      f.has_many :package_deals, new_record: 'Voeg een thema toe', allow_destroy: true do |pd|
        pd.input :package, as: :select, collection: Package.all.map{|p| ["#{p.name} (&euro;#{number_with_precision p.price})".html_safe, p.id]}
        pd.input :price
      end
    end
  end

  render 'onsgeheim/address/form', f: f, context: self
  actions
end