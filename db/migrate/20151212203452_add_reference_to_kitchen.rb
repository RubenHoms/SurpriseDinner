class AddReferenceToKitchen < ActiveRecord::Migration
  def change
    add_reference(:kitchens, :booking)
  end
end
