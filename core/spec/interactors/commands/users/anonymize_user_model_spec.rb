require 'spec_helper'

describe Commands::Users::AnonymizeUserModel do
  describe '#call' do
    it 'anonymizes fields of the user that could contain personal data' do
      user = create :active_user,
        password: '123hoi',
        password_confirmation: '123hoi'

      described_class.new(user_id: user.id).call

      saved_user = User.find(user.id)
      expect(saved_user.first_name).to eq 'anonymous'
      expect(saved_user.last_name).to eq 'anonymous'
      expect(saved_user.location).to eq ''
      expect(saved_user.biography).to eq ''
      expect(saved_user.twitter).to eq ''
      expect(saved_user.valid_password?('123hoi')).to be_false
      expect(saved_user.identities['twitter']).to eq nil
      expect(saved_user.identities['facebook']).to eq nil
    end

    it 'generates some anonymous username and email' do
      user = create :active_user

      described_class.new(user_id: user.id).call

      saved_user = User.find(user.id)
      expect(saved_user.username).to include('anonymous')
      expect(saved_user.email).to eq "deleted+#{saved_user.username}@factlink.com"
    end
  end
end
