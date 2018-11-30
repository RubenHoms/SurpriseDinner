class MakePreferencePolymorphic < ActiveRecord::Migration
  def change
    change_table :preferences do |t|
      t.references :preferential, polymorphic: true, index: true
      remove_column :preferences, :booking_id
      remove_column :preferences, :restaurant_id
    end
  end
end
