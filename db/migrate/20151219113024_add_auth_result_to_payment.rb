class AddAuthResultToPayment < ActiveRecord::Migration
  def change
    change_table :payments do |t|
      t.string :auth_result
    end
  end
end
