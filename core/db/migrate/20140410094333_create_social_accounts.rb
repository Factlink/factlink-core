class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.string :provider_name
      t.string :omniauth_obj_id
      t.integer :user_id
      t.text :omniauth_obj_string

      t.timestamps
    end
    add_index :social_accounts, :user_id
  end
end
