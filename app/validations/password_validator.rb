class PasswordValidator < ActiveModel::Validator
  def validate(record)
    return if record.password.blank? && !record.encrypted_password.blank?

    case record.password
    when /\A[a-zA-Z]+\z/
      record.errors.add :password, 'should also contain numbers or special characters'
    when /\A[0-9]+\z/
      record.errors.add :password, 'cannot consist of only numbers'
    end
  end
end
