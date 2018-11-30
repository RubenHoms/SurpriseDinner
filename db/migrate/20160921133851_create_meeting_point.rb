class CreateMeetingPoint < ActiveRecord::Migration
  def up
    create_table :meeting_points do |t|
      t.string :name
      t.text :description
    end
  end

  def down
    drop_table :meeting_points
  end
end
