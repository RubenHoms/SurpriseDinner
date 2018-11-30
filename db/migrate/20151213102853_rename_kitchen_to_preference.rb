class RenameKitchenToPreference < ActiveRecord::Migration
  def change
    rename_table :kitchens, :preferences
  end
end
