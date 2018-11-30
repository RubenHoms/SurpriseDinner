class AddXmlFileToSettlementBatch < ActiveRecord::Migration
  def change
    add_column :settlement_batches, :xml, :text
  end
end
