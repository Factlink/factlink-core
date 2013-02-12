authority = Authority.on(subject, for: user.graph_user).to_f + 1.0

json.partial! 'users/user_partial', user: user
json.authority_for_subject do |json|
  json.authority NumberFormatter.new(authority).as_authority
  json.id subject.id
end
