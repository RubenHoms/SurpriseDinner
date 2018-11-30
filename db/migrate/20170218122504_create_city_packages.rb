class CreateCityPackages < ActiveRecord::Migration
  def change
    create_table :city_packages do |t|
      t.integer :package_id
      t.integer :city_id
    end
  end
end
