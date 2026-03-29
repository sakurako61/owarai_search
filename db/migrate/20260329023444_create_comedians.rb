class CreateComedians < ActiveRecord::Migration[7.2]
  def change
    create_table :comedians do |t|
      t.string :name, null: false
      t.timestamps
      t.references :agency, foreign_key: true
    end
  end
end
