class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :groupname, null: false
      t.index [:groupname], unique:true
    end

    create_table :groups_users, id: false do |t|
      t.integer :group_id, null: false
      t.integer :user_id, null: false
      t.index [:group_id, :user_id], unique: true
      t.index [:user_id, :group_id]
    end

    add_column :fact_data, :group_id, :integer
  end
end
