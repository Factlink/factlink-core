require 'spec_helper'

describe PasswordValidator do
  it 'returns nil when the password attribute is blank and an encrypted password is saved' do
    user = build_stubbed :user, password: '', encrypted_password: 'some-encrypted-password'

    expect(subject.validate user)
      .to be_nil
  end

  it 'returns an error when the password is contains only letters' do
    user = build_stubbed :user, password: 'Password'

    expect(subject.validate user)
      .to eq ['should also contain numbers or special characters']
  end

  it 'returns an error when the password is contains only numbers' do
    user = build_stubbed :user, password: '1234567890'

    expect(subject.validate user)
      .to eq ['cannot consist of only numbers']
  end

end
