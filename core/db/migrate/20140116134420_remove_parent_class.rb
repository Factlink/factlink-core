class RemoveParentClass < Mongoid::Migration
  def self.up
    SubComment.all.each do |sub_comment|
      sub_comment.remove_field(:parent_class)
      sub_comment.save!(validate: false)
    end
  end

  def self.down
  end
end
