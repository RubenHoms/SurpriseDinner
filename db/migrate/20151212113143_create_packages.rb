class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.timestamps null: false
      t.string :name
      t.float :price
    end
  end
end
