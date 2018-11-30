class CreateSettlementBatch < ActiveRecord::Migration
  def change
    create_table :settlement_batches do |t|
      t.string :name
      t.datetime :settled_at
      t.timestamps
    end
  end
end
