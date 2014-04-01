class Export
  def export
    output = ''

    User.all.each do |user|
      output << 'user = User.new({'
      output << hash_field_for(user, 'username')
      output << hash_field_for(user, 'full_name')
      output << hash_field_for(user, 'location')
      output << hash_field_for(user, 'biography')
      output << hash_field_for(user, 'receives_mailed_notifications')
      output << hash_field_for(user, 'receives_digest')
      output << '}); '

      output << assignment_for(user, 'user', 'created_at')
      output << assignment_for(user, 'user', 'updated_at')
      output << assignment_for(user, 'user', 'deleted')
      output << assignment_for(user, 'user', 'admin')
      output << assignment_for(user, 'user', 'email')
      output << assignment_for(user, 'user', 'registration_code')
      output << assignment_for(user, 'user', 'reset_password_token')
      output << assignment_for(user, 'user', 'reset_password_sent_at')
      output << assignment_for(user, 'user', 'remember_created_at')
      output << assignment_for(user, 'user', 'sign_in_count')
      output << assignment_for(user, 'user', 'current_sign_in_at')
      output << assignment_for(user, 'user', 'last_sign_in_at')
      output << assignment_for(user, 'user', 'current_sign_in_ip')
      output << assignment_for(user, 'user', 'last_sign_in_ip')

      output << 'user.password = "some_dummy"; ' # before setting encrypted_password
      output << assignment_for(user, 'user', 'encrypted_password')

      output << 'user.skip_confirmation_notification!; '
      output << 'user.save!; '
      output << assignment_for(user, 'user', 'confirmed_at')
      output << assignment_for(user, 'user', 'confirmation_token')
      output << assignment_for(user, 'user', 'confirmation_sent_at')
      output << assignment_for(user, 'user', 'updated_at') # set here again explicitly to prevent overwriting
      output << 'user.save!'
      output << "\n"

      user.social_accounts.each do |social_account|
        output << 'SocialAccount.create!({'
        output << hash_field_for(social_account, 'provider_name')
        output << hash_field_for(social_account, 'omniauth_obj')
        output << 'user: User.find(' + to_ruby(user, 'username') + '), '
        output << '})'
        output << "\n"
      end
    end

    output
  end

  private

  def to_ruby(object, name)
    value = object.send(name)

    if value.is_a?(Time)
      return 'Time.parse(' + value.utc.iso8601.inspect + ')'
    else
      return value.inspect
    end
  end

  def hash_field_for(object, name)
    name + ': ' + to_ruby(object, name) + ', '
  end

  def assignment_for(object, object_name, name)
    object_name + '.' + name + ' = ' + to_ruby(object, name) + '; '
  end
end
