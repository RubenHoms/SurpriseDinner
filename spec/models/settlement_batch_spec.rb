# == Schema Information
#
# Table name: settlement_batches
#
#  id         :integer          not null, primary key
#  name       :string
#  settled_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  xml        :text
#

require 'rails_helper'

describe SettlementBatch do
  let!(:settlement_batch) { FactoryGirl.create(:settlement_batch) }
  let!(:settlements) { FactoryGirl.create_list(:settlement, 10, settlement_batch: settlement_batch) }
  let!(:settlement_batch_settled) { FactoryGirl.create(:settlement_batch_settled) }

  before do
    allow(Rails).to receive_message_chain(:application, :secrets, :iban_from).and_return('NL76TRIO0338417702')
    allow(Rails).to receive_message_chain(:application, :secrets, :bic_from).and_return('TRIONL2U')
  end

  it 'has a valid factory' do
    expect(settlement_batch).to be_valid
  end

  context 'validations' do
    %w(name).each do |field|
      it "should have #{field}" do
        settlement_batch.send("#{field}=", nil)
        expect(settlement_batch).to_not be_valid
      end
    end
  end

  context 'public methods' do
    it '#settled?' do
      expect(settlement_batch_settled.settled?).to be true
    end

    it '#settle' do
      expect{ settlement_batch.settle }.to change{ settlement_batch.settled_at }
      expect{ settlement_batch.settle }.to_not change{ settlement_batch.settled_at }
    end

    it '#to_xml' do
      xml = settlement_batch.to_xml
      settlements.each_with_index do |settlement, index|
        expect(xml).to have_xml "//Document/CstmrCdtTrfInitn/PmtInf/CdtTrfTxInf[#{index+1}]"
      end
    end

    it '#save_xml' do
      expect{ settlement_batch.save_xml }.to change{ settlement_batch.xml }
      expect{ settlement_batch.settle and settlement_batch.save_xml }.to_not change { settlement_batch.xml }
    end
  end

  context 'callbacks' do
    it '#settled_check should not destroy if was settled' do
      expect{ settlement_batch_settled.destroy }.to_not change{ described_class.count }
    end
  end
end
