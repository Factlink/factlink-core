class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :notification_settings_edit_token
      t.string :username
      t.string :full_name
      t.text :location
      t.text :biography
      t.string :graph_user_id
      t.boolean :deleted
      t.boolean :admin
      t.boolean :receives_mailed_notifications
      t.boolean :receives_digest

      t.timestamps
    end
  end
end
