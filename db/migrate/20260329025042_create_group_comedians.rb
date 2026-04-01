class CreateGroupComedians < ActiveRecord::Migration[7.2]
  def change
    create_table :group_comedians do |t|
      t.references :group, null: false, foreign_key: true
      t.references :comedian, null: false, foreign_key: true

      t.timestamps
    end
  end
end
