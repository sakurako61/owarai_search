class RenameDiscriptionToDescriptionInPosts < ActiveRecord::Migration[7.2]
  def change
    rename_column :posts, :discription, :description
  end
end
