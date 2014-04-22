class CommentVotesToSql < ActiveRecord::Migration
  def up
    Comment.all.each do |comment|
      believes_ids = Nest.new("Comment:#{comment.id}:believable:people_believes").smembers
      disbelieves_ids = Nest.new("Comment:#{comment.id}:believable:people_disbelieves").smembers

      believes_ids.each do |user_id|
        Backend::Comments.set_opinion comment_id: comment.id, user_id: user_id, opinion: 'believes'
      end
      disbelieves_ids.each do |user_id|
        Backend::Comments.set_opinion comment_id: comment.id, user_id: user_id, opinion: 'disbelieves'
      end
    end
  end

  def down
  end
end
