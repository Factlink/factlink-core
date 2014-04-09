class FactlinkImport
  def user fields
    user = User.new

    field_names = [:username, :full_name, :location, :biography,
      :receives_digest, :receives_mailed_notifications, :created_at,
      :updated_at, :deleted, :admin, :email,
      :registration_code, :reset_password_token, :reset_password_sent_at,
      :remember_created_at, :sign_in_count, :current_sign_in_at,
      :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip]
    field_names.each do |name|
      user.public_send("#{name}=", fields[name])
    end
    user.password = "some_dummy" # before setting encrypted_password
    user.encrypted_password = fields[:encrypted_password]
    user.skip_confirmation_notification!
    user.save!

    user.confirmed_at = fields[:confirmed_at]
    user.confirmation_token = fields[:confirmation_token]
    user.confirmation_sent_at = fields[:confirmation_sent_at]
    user.save!

    # set here again explicitly, without other assignments, to prevent overwriting
    user.updated_at = fields[:updated_at]
    user.save!
  end

  def social_account fields
    field_names = [:provider_name, :omniauth_obj, :created_at, :updated_at]
    SocialAccount.create! fields.slice(*field_names) + [user: User.find(fields[:username])]
  end

  def fact fields
    Pavlov.interactor(:'facts/create', fact_id: fields[:fact_id],
      displaystring: fields[:displaystring], site_title: fields[:title],
      url: fields[:site_url], pavlov_options: pavlov_options(time: fields[:created_at]))
  end

  private def pavlov_options(time:)
    {
      current_user: nil,
      ability: nil,
      send_mails: false,
      time: time,
      import: true,
    }
  end
end
