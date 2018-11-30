class RemoveNullFromNotes < ActiveRecord::Migration
  def change
    change_column :bookings, :notes, :text, null: true
  end
end
