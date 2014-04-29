class RenameUserIdToCreatedById < ActiveRecord::Migration
  def change
    rename_column :fact_data, :user_id, :created_by_id
  end
end
