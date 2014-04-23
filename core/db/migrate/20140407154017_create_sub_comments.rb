class CreateSubComments < ActiveRecord::Migration
  def change
    create_table :sub_comments do |t|
      t.integer :parent_id
      t.text :content
      t.string :created_by_id

      t.timestamps
    end

    add_index :sub_comments, :parent_id
  end
end
