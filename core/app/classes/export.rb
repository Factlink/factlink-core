class Export
  def export
    output = ''

    User.all.each do |user|
      output << import('user', fields_from_object(user, User.import_export_simple_fields + [
        :encrypted_password, :confirmed_at, :confirmation_token, :confirmation_sent_at
      ])) + "\n"

      user.social_accounts.each do |social_account|
        output << import('social_account',
          fields_from_object(social_account, SocialAccount.import_export_simple_fields).merge(
            username: user.username)
        ) + "\n"
      end
    end

    FactData.all.each do |fact_data|
      output << import('fact', fields_from_object(fact_data, [
        :fact_id, :displaystring, :title, :url, :created_at
      ])) + "\n"
    end

    Comment.all.each do |comment|
      output << import('comment',
        fields_from_object(comment, [:content, :created_at]).merge(
          fact_id: comment.fact_data.fact_id, username: comment.created_by.username)
      ) + "\n"
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

  def fields_from_object(object, field_names)
    field_names.inject({}) { |hash, name| hash.merge(name => object.public_send(name)) }
  end

  def import(name, fields)
    fields_string = fields.map{ |name, value| name_value_to_string(name, value)}.join

    "FactlinkImport.#{name}({#{fields_string}})"
  end
end
