class AddUserIdToFactData < ActiveRecord::Migration
  def change
    add_column :fact_data, :user_id, :integer
  end
end
