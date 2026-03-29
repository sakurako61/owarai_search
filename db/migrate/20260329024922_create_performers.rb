class CreatePerformers < ActiveRecord::Migration[7.2]
  def change
    create_table :performers do |t|
      t.references :post, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :comedian, null: false, foreign_key: true

      t.timestamps
    end
  end
end
