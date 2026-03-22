class AddUserImageToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :user_image, :string
  end
end
