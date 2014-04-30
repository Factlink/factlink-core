class ChangeCommentMarkupFormatDefault < ActiveRecord::Migration
  def change
    change_column :comments, :markup_format, :string,
      :default => 'plaintext', :null => false
  end
end
