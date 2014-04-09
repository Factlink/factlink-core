class Export
  def export
    output = ''

    User.all.each do |user|
      output << import('user', user, User.import_export_simple_fields + [
        :encrypted_password, :confirmed_at, :confirmation_token,
        :confirmation_sent_at, :updated_at
      ])

      user.social_accounts.each do |social_account|
        output << import('social_account', social_account,
          SocialAccount.import_export_simple_fields,
          additional: {username: user.username})
      end
    end

    FactData.all.each do |fact_data|
      output << import('fact', fact_data, [
        :fact_id, :displaystring, :title, :url, :created_at
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

  def name_value_to_string(name, value)
    name.to_s + ': ' + to_ruby(value) + ', '
  end

  def hash_field_for(object, name)
    name_value_to_string(name, object.public_send(name))
  end

  def import(name, object, fields, additional:{})
    object_fields = fields.map { |name| hash_field_for(object, name) }.join
    additional_string = additional.map{ |name, value| name_value_to_string(name, value)}.join

    "FactlinkImport.new.#{name}({#{object_fields}#{additional_string}})\n"
  end
end
