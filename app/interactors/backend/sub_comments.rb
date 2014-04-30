module Backend
  module SubComments
    extend self

    def count(parent_id:)
      SubComment.where(parent_id: parent_id.to_s).count
    end

    def index(parent_ids_in:)
      sub_comments = SubComment.where(parent_id: parent_ids_in).order("created_at ASC")
      sub_comments.map do |sub_comment|
        dead_for(sub_comment)
      end
    end

    def destroy!(id:)
      SubComment.find(id).destroy
    end

    def create!(parent_id:, content:, user:, created_at:)
      sub_comment = SubComment.new
      sub_comment.parent_id = parent_id.to_s
      sub_comment.created_by = user
      sub_comment.content = content
      sub_comment.created_at = created_at
      sub_comment.updated_at = created_at
      sub_comment.save!

      sub_comment
    end

    def dead_for(sub_comment)
      created_by = Backend::Users.by_ids(user_ids: [sub_comment.created_by_id]).first
      DeadSubComment.new id: sub_comment.id,
                         created_by: created_by,
                         created_by_id: sub_comment.created_by_id,
                         created_at: sub_comment.created_at,
                         content: sub_comment.content,
                         parent_id: sub_comment.parent_id
    end
  end
end
