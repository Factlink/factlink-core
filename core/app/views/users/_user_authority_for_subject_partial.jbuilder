authority = Authority.on(subject, for: user.graph_user).to_f + 1.0
authority_for_subject = {
  authority: NumberFormatter.new(authority).as_authority,
  id: subject.id
}

json.partial! 'users/user_partial', user: user

# OBSOLETE:
json.avatar                 image_tag(user.avatar_url(size: 32), title: user.username, alt: user.username, width: 32)

json.authority_for_subject  authority_for_subject
