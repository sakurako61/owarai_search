class RemoveUserImageFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :user_image, :string
  end
end
