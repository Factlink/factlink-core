authority = Authority.on(subject, for: user.graph_user).to_f + 1.0
authority_for_subject = {
  authority: NumberFormatter.new(authority).as_authority,
  id: subject.id
}

json.id                     user.id.to_s
json.name                   user.name.to_s.empty? ? user.username : user.name
json.username               user.username
json.avatar                 image_tag(user.avatar_url(size: 32), title: user.username, alt: user.username, width: 32)
json.url                    user_profile_path(user)
json.authority_for_subject  authority_for_subject
