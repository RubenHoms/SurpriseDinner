context.instance_eval do
  panel 'Betalingsopdrachten' do
    table_for settlement_batch.settlements do
      column :restaurant
      column :booking
      column :total_amount
      column :restaurant_iban
      column :restaurant_bic
    end
  end
end