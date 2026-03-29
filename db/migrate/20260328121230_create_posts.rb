class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :live_name, null: false
      t.string :discription
      t.datetime :open_date
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :ticket_start_date
      t.datetime :ticket_end_date
      t.integer :price
      t.text :live_url, null: false

      t.references :user, foreign_key: true
      t.references :place, foreign_key: true

      t.timestamps
    end
  end
end
