class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title
      t.text :content
      t.boolean :published

      t.timestamps null: false
    end
  end
end
