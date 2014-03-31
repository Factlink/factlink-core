require 'spec_helper'

describe Backend::Users do
  include PavlovSupport

  describe '.delete' do
    it 'anonymizes fields of the deleted user that could contain personal data' do
      user = create :user, :confirmed,
        username: 'data',
        full_name: 'data',
        location: 'data',
        biography: 'data',
        password: '123hoi',
        password_confirmation: '123hoi',
        deleted: true,
        reset_password_token: 'data',
        confirmation_token: 'data'

      create :social_account, :twitter, user: user
      create :social_account, :facebook, user: user

      expect(user.social_accounts.size).to eq 2

      described_class.delete username: user.username

      saved_user = User.find(user.id)
      expect(saved_user).to_not be_active
      expect(saved_user).to be_hidden
      expect(saved_user.deleted).to be_true

      expect(saved_user.full_name).to_not include('data')
      expect(saved_user.username).to_not include('data')
      expect(saved_user.location).to be_nil
      expect(saved_user.biography).to be_nil

      expect(saved_user.social_accounts.size).to eq 0
      expect(SocialAccount.all.size).to eq 0

      # TODO: we might want to extract "deauthorizing someone" to a
      # separate command at some point
      expect(saved_user.valid_password?('123hoi')).to be_false
      expect(saved_user.reset_password_token).to be_nil

      expect(saved_user.confirmation_token).to be_nil
      expect(saved_user.confirmed_at).to be_nil
      expect(saved_user.confirmed?).to be_false

      expect(saved_user.email).to eq "deleted+#{saved_user.username}@factlink.com"
    end
  end
end
