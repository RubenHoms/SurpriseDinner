context.instance_eval do
  f.inputs 'Meeting point details' do
    f.input :name
    f.input :description
  end

  render 'onsgeheim/address/form', f: f, context: self
  actions
end