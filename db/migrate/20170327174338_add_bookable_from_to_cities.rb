class AddBookableFromToCities < ActiveRecord::Migration
  def change
    add_column :cities, :bookable_from, :datetime
  end
end
