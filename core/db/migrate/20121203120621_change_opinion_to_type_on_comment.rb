class ChangeOpinionToTypeOnComment < Mongoid::Migration
  def self.up
    Comment.all.each do |comment|
      comment.type = comment.opinion
      comment.unset :opinion
      comment.save
    end
  end

  def self.down
    Comment.all.each do |comment|
      comment.opinion = comment.type
      comment.unset :type
      comment.save
    end
  end
end
