context.instance_eval do
  panel 'Betalingen' do
    table_for payments do
      column :created_at
      column :payment_status
      column :amount
      column :paid_at
    end
    span do
      button_to 'Betaling aanvragen', request_payment_onsgeheim_booking_path(booking),
                method: :get, data: { confirm: 'Dit zal een betalingsaanvraag versturen, weet je het zeker?' }
    end
  end
end