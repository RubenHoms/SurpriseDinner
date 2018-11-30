class AddMeetingPointToRestaurant < ActiveRecord::Migration
  def up
    add_column :restaurants, :meeting_point_id, :integer
  end

  def down
    remove_column :restaurants, :meeting_point_id
  end
end
