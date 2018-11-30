context.instance_eval do
  f.inputs 'Coupon' do
    f.input :code
    f.input :discount_percentage
    f.input :expires_at, as: :string, input_html: { class: 'form-control datepicker' }
  end

  actions
end