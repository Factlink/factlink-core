module FactlinkImport
  extend self

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
    create_fields = fields.slice(*SocialAccount.import_export_simple_fields)
    create_fields[:user] = user_for(fields[:username])
    SocialAccount.create! create_fields
  end

  def fact fields
    ExecuteAsUser.new(nil).execute do |pavlov|
      pavlov.import = true
      pavlov.time = fields[:created_at]
      pavlov.interactor(:'facts/create', fact_id: fields[:fact_id],
        displaystring: fields[:displaystring], site_title: fields[:title],
        site_url: fields[:url])
    end
  end

  def comment fields
    ExecuteAsUser.new(user_for(fields[:username])).execute do |pavlov|
      pavlov.import = true
      pavlov.time = fields[:created_at]
      pavlov.interactor(:'comments/create', fact_id: fields[:fact_id], content: fields[:content])
    end
  end

  private def user_for username
    @user_for ||= {}
    @user_for[username] ||= User.find(username) or fail "Username '#{username}' not found"
  end
end
