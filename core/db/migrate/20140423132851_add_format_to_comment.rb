class AddFormatToComment < ActiveRecord::Migration
  def change
    add_column :comments, :format, :string
  end
end
