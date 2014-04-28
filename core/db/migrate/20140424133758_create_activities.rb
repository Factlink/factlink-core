class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :action
      t.string :subject_type
      t.integer :subject_id
      t.integer :user_id

      t.timestamps
    end

    add_index :activities, :action
    add_index :activities, :user_id
  end
end
