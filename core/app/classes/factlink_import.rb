class FactlinkImport
  def user fields
    user = User.new

    User.import_export_simple_fields.each do |name|
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
    create_fields = fields.slice(SocialAccount.import_export_simple_fields) + [user: User.find(fields[:username])]
    SocialAccount.create! create_fields
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
