class Export
  def export
    output = ''

    User.all.each do |user|
      output << import('user', user, [
        :username, :full_name, :location, :biography,
        :receives_digest, :receives_mailed_notifications, :created_at,
        :updated_at, :deleted, :admin, :email,
        :registration_code, :reset_password_token, :reset_password_sent_at,
        :remember_created_at, :sign_in_count, :current_sign_in_at,
        :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip,
        :encrypted_password, :confirmed_at, :confirmation_token, :confirmation_sent_at,
        :updated_at
      ])

      user.social_accounts.each do |social_account|
        output << import('social_account', social_account, [
          :provider_name, :omniauth_obj, :created_at, :updated_at
        ], 'username: ' + to_ruby(user.username))
      end
    end

    FactData.all.each do |fact_data|
      output << import('fact', fact_data, [
        :fact_id, :displaystring, :title, :site_url, :created_at
      ])
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
    name.to_s + ': ' + to_ruby(object.public_send(name)) + ', '
  end

  def import(name, object, fields, additional_fields="")
    object_fields = fields.map { |name| hash_field_for(object, name) }.join('')
    "FactlinkImport.new.#{name}({#{object_fields}#{additional_fields}})\n"
  end
end
