json.id           sub_comment.id
json.content      sub_comment.content

json.created_by do |json|
  json.partial! 'users/user_partial', user: sub_comment.created_by
  json.authority sub_comment.authority
end
