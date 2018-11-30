class CreateKitchens < ActiveRecord::Migration
  def change
    create_table :kitchens do |t|
      t.timestamps null: false
      [:gluten_free, :soja_free, :nuts_free, :vegeratian].each do |preference|
        t.string "#{preference}_available"
      end
    end
  end
end
