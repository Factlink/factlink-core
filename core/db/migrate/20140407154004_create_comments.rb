class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :fact_data_id
      t.text :content
      t.string :created_by_id

      t.timestamps
    end

    add_index :comments, :fact_data_id
  end
end
