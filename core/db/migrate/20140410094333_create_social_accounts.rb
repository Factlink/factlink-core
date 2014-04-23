class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.string :provider_name
      t.string :omniauth_obj_id
      t.string :user_id
      t.text :omniauth_obj_string

      t.timestamps
    end
  end
end
