# == Schema Information
#
# Table name: meeting_points
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#

require 'rails_helper'

describe MeetingPoint do
  let!(:meeting_point) { FactoryGirl.create(:meeting_point) }
  let!(:restaurant) { FactoryGirl.create(:restaurant, meeting_point: meeting_point)}
  let(:invalid_meeting_point_address) { FactoryGirl.build(:invalid_meeting_point_address) }

  it 'should have a valid factory' do
    expect(meeting_point).to be_valid
  end

  context 'validations' do
    it 'should not delete if it has associated restaurants' do
      expect{ meeting_point.destroy }.to_not change { MeetingPoint.count }
    end

    it 'should have an address' do
      expect(invalid_meeting_point_address).to_not be_valid
    end
  end

  context 'methods' do
    pending
  end
end
