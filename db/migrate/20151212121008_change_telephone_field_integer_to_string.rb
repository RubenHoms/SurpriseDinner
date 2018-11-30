class ChangeTelephoneFieldIntegerToString < ActiveRecord::Migration
  def change
    change_column(:bookings, :telephone, :string)
  end
end
