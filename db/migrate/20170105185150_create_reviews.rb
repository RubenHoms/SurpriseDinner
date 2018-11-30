class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :quote
      t.string :name
      t.boolean :featured, default: false

      t.timestamps null: false
    end
  end
end
