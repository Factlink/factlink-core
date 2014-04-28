class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end

    add_index :features, [:user_id, :name], unique: true
  end
end
