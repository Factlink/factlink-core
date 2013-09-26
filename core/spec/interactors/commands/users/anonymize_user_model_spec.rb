require 'spec_helper'

describe Commands::Users::AnonymizeUserModel do
  describe '#call' do
    it 'anonymizes fields of the deleted user that could contain personal data' do
      user = create :full_user,
        username: 'data',
        first_name: 'data',
        last_name: 'data',
        location: 'data',
        biography: 'data',
        twitter: 'data',
        identities: {'twitter' => 'data', 'facebook' => 'data'},
        password: '123hoi',
        password_confirmation: '123hoi',
        deleted: true,
        reset_password_token: 'data',
        confirmation_token: 'data',
        invitation_token: 'data'

      described_class.new(user_id: user.id).call

      saved_user = User.find(user.id)
      expect(saved_user.first_name).to_not include('data')
      expect(saved_user.last_name).to_not include('data')
      expect(saved_user.username).to_not include('data')
      expect(saved_user.location).to be_nil
      expect(saved_user.biography).to be_nil
      expect(saved_user.twitter).to be_nil

      expect(saved_user.identities['twitter']).to eq nil
      expect(saved_user.identities['facebook']).to eq nil

      # TODO: we might want to extract "deauthorizing someone" to a
      # separate command at some point
      expect(saved_user.valid_password?('123hoi')).to be_false
      expect(saved_user.reset_password_token).to be_nil
      expect(saved_user.confirmation_token).to be_nil
      expect(saved_user.invitation_token).to be_nil

      expect(saved_user.email).to eq "deleted+#{saved_user.username}@factlink.com"
    end

    it "doesn't do anything for non-deleted users" do
      user = create :full_user, username: 'data'

      described_class.new(user_id: user.id).call

      saved_user = User.find(user.id)
      expect(saved_user.username).to eq 'data'
    end
  end
end
