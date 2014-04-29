class AddFormatToComment < ActiveRecord::Migration
  def change
    add_column :comments, :markup_format, :string
  end
end
