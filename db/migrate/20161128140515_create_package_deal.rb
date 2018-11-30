class CreatePackageDeal < ActiveRecord::Migration
  def up
    create_table :package_deals do |t|
      t.integer :restaurant_id
      t.integer :package_id
      t.float :price
      t.timestamps
    end
  end

  def down
    drop_table :package_deals
  end
end
