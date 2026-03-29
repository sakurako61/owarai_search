class CreatePlaces < ActiveRecord::Migration[7.2]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :post_code, limit: 8
      t.string :address, null: false
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
