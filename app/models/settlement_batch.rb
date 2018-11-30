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

class SettlementBatch < ActiveRecord::Base
  has_many :settlements, dependent: :destroy

  validates :name, presence: true

  before_destroy :settled_check

  def settled?
    settled_at?
  end

  def settle
    return if settled?
    touch :settled_at
  end

  def to_xml
    sct = credit_transfer
    settlements.each{|s| sct.add_transaction(s.to_transaction)}
    sct.to_xml('pain.001.001.03')
  end

  def save_xml
    return if settled?
    update_attribute :xml, to_xml
  end

  private

  def credit_transfer
    SEPA::CreditTransfer.new(
        # Name of the initiating party and debtor, in German: "Auftraggeber"
        # String, max. 70 char
        name: 'Surprise Dinner',

        # International Bank Account Number of the debtor
        # String, max. 34 chars
        iban: Rails.application.secrets.iban_from,

        bic: Rails.application.secrets.bic_from
    )
  end

  def settled_check
    if settled?
      errors.add(:name, 'is verwerkt en kan niet verwijderd worden.')
      return false
    end
  end
end
