class ResaveSubcomments < Mongoid::Migration
  def self.up
    SubComment.each do |sub_comment|
      # Save again to convert to Moped::BSON::ObjectId
      sub_comment.parent_id = sub_comment.parent_id

      sub_comment.save!
    end
  end

  def self.down
  end
end
