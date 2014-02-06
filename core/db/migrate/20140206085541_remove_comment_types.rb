class RemoveCommentTypes < Mongoid::Migration
  def self.up
    Comment.all.each do |comment|
      comment.remove_attribute(:type)
    end

  end

  def self.down
  end
end
