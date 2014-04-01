def marshall(object, name)
  value = object.send(name)

  if value.is_a?(Time)
    return 'Time.parse(' + value.utc.iso8601.inspect + ')'
  else
    return value.inspect
  end
end

def hash_field_for(object, name)
  name + ': ' + marshall(object, name) + ', '
end

def assignment_for(object, object_name, name)
  object_name + '.' + name + ' = ' + marshall(object, name) + '; '
end

def export_database(filename:)
  File.open(filename, 'w') do |file|
    User.all.each do |user|
      user_export = 'user = User.new({'
      user_export += hash_field_for(user, 'username')
      user_export += hash_field_for(user, 'full_name')
      user_export += hash_field_for(user, 'location')
      user_export += hash_field_for(user, 'biography')
      user_export += hash_field_for(user, 'receives_mailed_notifications')
      user_export += hash_field_for(user, 'receives_digest')
      user_export += '}); '


      user_export += assignment_for(user, 'user', 'created_at')
      user_export += assignment_for(user, 'user', 'updated_at')
      user_export += assignment_for(user, 'user', 'deleted')
      user_export += assignment_for(user, 'user', 'admin')
      user_export += assignment_for(user, 'user', 'email')
      user_export += assignment_for(user, 'user', 'registration_code')
      user_export += assignment_for(user, 'user', 'reset_password_token')
      user_export += assignment_for(user, 'user', 'reset_password_sent_at')
      user_export += assignment_for(user, 'user', 'remember_created_at')
      user_export += assignment_for(user, 'user', 'sign_in_count')
      user_export += assignment_for(user, 'user', 'current_sign_in_at')
      user_export += assignment_for(user, 'user', 'last_sign_in_at')
      user_export += assignment_for(user, 'user', 'current_sign_in_ip')
      user_export += assignment_for(user, 'user', 'last_sign_in_ip')

      user_export += 'user.password = "some_dummy"; ' # before setting encrypted_password
      user_export += assignment_for(user, 'user', 'encrypted_password')

      user_export += 'user.skip_confirmation_notification!; '
      user_export += 'user.save!; '
      user_export += assignment_for(user, 'user', 'confirmed_at')
      user_export += assignment_for(user, 'user', 'confirmation_token')
      user_export += assignment_for(user, 'user', 'confirmation_sent_at')
      user_export += assignment_for(user, 'user', 'updated_at') # set here again explicitly to prevent overwriting
      user_export += 'user.save!'

      file.puts user_export

      user.social_accounts.each do |social_account|
        social_account_export = 'SocialAccount.create!({'
        social_account_export += hash_field_for(social_account, 'provider_name')
        social_account_export += hash_field_for(social_account, 'omniauth_obj')
        social_account_export += 'user: User.find(' + marshall(user, 'username') + '), '
        social_account_export += '})'

        file.puts social_account_export
      end
    end
  end
end
