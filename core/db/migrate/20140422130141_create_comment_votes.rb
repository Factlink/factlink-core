class CreateCommentVotes < ActiveRecord::Migration
  def change
    create_table :comment_votes do |t|
      t.integer :comment_id
      t.integer :user_id
      t.string :opinion

      t.timestamps
    end

    add_index :comment_votes, :comment_id
    add_index :comment_votes, :user_id
  end
end
