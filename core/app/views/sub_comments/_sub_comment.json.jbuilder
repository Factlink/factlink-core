json.id           sub_comment.id
json.formatted_content FormattedCommentContent.new(sub_comment.content).html
json.created_at   sub_comment.created_at
json.created_by sub_comment.created_by
