class RemoveParentClass < Mongoid::Migration
  def self.up
    SubComment.all.unset('parent_class')
  end

  def self.down
  end
end
