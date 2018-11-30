ActiveAdmin.register SettlementBatch do
  config.sort_order = 'created_at_desc'

  filter :name, label: 'Naam'
  filter :settled_at

  actions :index, :show, :destroy

  show do
    render 'show', context: self
  end

  index do
    id_column
    column :name
    column :settled_at
    column {|batch| link_to 'Opnieuw genereren', Rails.application.routes.url_helpers.regenerate_xml_onsgeheim_settlement_batch_url(batch) }
    column {|batch| link_to 'Verwerken', Rails.application.routes.url_helpers.settle_onsgeheim_settlement_batch_url(batch) }
    column {|batch| link_to 'Batch downloaden', Rails.application.routes.url_helpers.download_onsgeheim_settlement_batch_url(batch) }
    actions
  end

  member_action :regenerate_xml do
    @settlement_batch = SettlementBatch.find(params[:id])
    @settlement_batch.save_xml
    redirect_to :onsgeheim_settlement_batches
  end

  member_action :settle do
    @settlement_batch = SettlementBatch.find(params[:id])
    @settlement_batch.settle
    redirect_to :onsgeheim_settlement_batches
  end

  member_action :download do
    @settlement_batch = SettlementBatch.find(params[:id])
    send_data @settlement_batch.xml, type: 'application/xml', filename: "#{@settlement_batch.name}.xml"
  end
end