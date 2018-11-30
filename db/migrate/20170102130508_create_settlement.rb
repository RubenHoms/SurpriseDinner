class CreateSettlement < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.references :booking
      t.references :restaurant
      t.references :settlement_batch
      t.monetize :total_amount
      t.timestamps
    end
  end
end
