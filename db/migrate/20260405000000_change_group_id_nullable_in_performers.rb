class ChangeGroupIdNullableInPerformers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :performers, :group_id, true
  end
end
