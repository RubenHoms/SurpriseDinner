class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.timestamps null: false
      t.string :amount
      t.integer :persons
      t.boolean :paid
    end
  end
end
