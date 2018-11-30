class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.timestamps null: false
      t.string :code
      t.timestamp :activated_at
    end
  end
end
