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

      assignment_fields = ['created_at', 'updated_at', 'deleted', 'admin', 'email',
       'registration_code', 'reset_password_token', 'reset_password_sent_at',
       'remember_created_at', 'sign_in_count', 'current_sign_in_at',
       'last_sign_in_at', 'current_sign_in_ip', 'last_sign_in_ip']

      output << assignment_fields.map do |name|
        assignment_for(user, 'user', name)
      end.join('')

      output << 'user.password = "some_dummy"; ' # before setting encrypted_password
      output << assignment_for(user, 'user', 'encrypted_password')

      output << 'user.skip_confirmation_notification!; '
      output << 'user.save!; '
      output << assignment_for(user, 'user', 'confirmed_at')
      output << assignment_for(user, 'user', 'confirmation_token')
      output << assignment_for(user, 'user', 'confirmation_sent_at')
      output << 'user.save!; '

      # set here again explicitly, without other assignments, to prevent overwriting
      output << assignment_for(user, 'user', 'updated_at')
      output << 'user.save!'
      output << "\n"

      user.social_accounts.each do |social_account|
        output << 'SocialAccount.create!({'
        output << hash_field_for(social_account, 'provider_name')
        output << hash_field_for(social_account, 'omniauth_obj')
        output << hash_field_for(social_account, 'created_at')
        output << hash_field_for(social_account, 'updated_at')
        output << 'user: User.find(' + to_ruby(user.username) + '), '
        output << '})'
        output << "\n"
      end
    end

    FactData.all.each do |fact_data|
      output << 'Pavlov.interactor(:"facts/create", {'
      output << hash_field_for(fact_data, 'fact_id')
      output << hash_field_for(fact_data, 'displaystring')
      output << 'site_title: ' + to_ruby(fact_data.title) + ', '
      output << 'url: ' + to_ruby(fact_data.site_url) + ', '
      output << pavlov_options(time: fact_data.created_at)
      output << '})'
      output << "\n"
    end

    Comment.all.each do |comment|
      output << 'Pavlov.interactor(:"comments/create", {'
      output << hash_field_for(comment, 'content')
      output << 'fact_id: ' + to_ruby(comment.fact_data.fact_id) + ', '
      output << pavlov_options(time: comment.created_at, user: comment.created_by)
      output << '})'
      output << "\n"
    end

    output
  end

  private

  def to_ruby(value)
    case value
    when Time
      return 'Time.parse(' + value.utc.iso8601.inspect + ')'
    when String, Integer, NilClass, TrueClass, FalseClass, Hash
      return value.inspect
    else
      fail "Unsupported type: " + value.class.name
    end
  end

  def hash_field_for(object, name)
    name + ': ' + to_ruby(object.send(name)) + ', '
  end

  def assignment_for(object, object_name, name)
    object_name + '.' + name + ' = ' + to_ruby(object.send(name)) + '; '
  end

  def pavlov_options(time:, user: nil)
    output = "pavlov_options: {"
    output << "time: #{to_ruby(time)}, "
    output << "send_mails: false, "
    if user
      output << "current_user: User.find(#{to_ruby(user.username)}), "
      output << "ability: Ability.new(User.find(#{to_ruby(user.username)})), "
    end
    output << "}, "
    output
  end
end
