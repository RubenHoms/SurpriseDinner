# == Schema Information
#
# Table name: codes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  activated_at :datetime
#  booking_id   :integer
#

require 'rails_helper'

describe Code do
  let(:booking) { FactoryGirl.create(:booking) }
  let(:code) { FactoryGirl.create(:code, booking: booking) }

  before do
    allow_any_instance_of(Mandrill::API)
        .to receive_message_chain(:templates, :render, '[]').and_return('')
  end

  it 'should have a valid factory' do
    expect(code).to be_valid
  end

  context 'validations' do
    it 'should have a 6 digit code' do
      the_code = code.code
      expect(the_code.length).to equal(6)
    end
  end

  context 'methods' do
    it 'should know when it is activated' do
      expect(code).not_to be_activated
      code.activate
      expect(code).to be_activated
    end
  end
end