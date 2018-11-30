class ChangeFieldsInKitchensToBooleans < ActiveRecord::Migration
  def change
    [:gluten_free, :soja_free, :nuts_free, :vegeratian].each do |preference|
      remove_column :kitchens, "#{preference}_available"
      add_column :kitchens, "#{preference}_available", :boolean
    end
    rename_column(:kitchens, :vegeratian_available, :vegetarian_available)
  end
end
