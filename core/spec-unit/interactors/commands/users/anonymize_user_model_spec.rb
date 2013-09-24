require 'pavlov_helper'
require 'ostruct'
require_relative '../../../../app/interactors/commands/users/anonymize_user_model'

describe Commands::Users::AnonymizeUserModel do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'User'
    end

    it 'anonymizes fields of the user that could contain personal data' do
      user = OpenStruct.new id: '1a', username: 'username'
      command = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return user

      expect(user).to receive(:save!) do
        expect(user.first_name).to eq 'anonymous'
        expect(user.last_name).to eq 'anonymous'
        expect(user.location).to eq ''
        expect(user.biography).to eq ''
        expect(user.twitter).to eq ''
        expect(user.password).to eq 'some_password_henk_gerard_gerrit'
        expect(user.password_confirmation).to eq 'some_password_henk_gerard_gerrit'
        expect(user.identities['twitter']).to eq nil
        expect(user.identities['facebook']).to eq nil
      end

      command.call
    end

    it 'generates some anonymous username and email' do
      user = OpenStruct.new id: '1a', username: 'username'
      command = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return user

      expect(user).to receive(:save!) do
        expect(user.username).to include('anonymous')
        expect(user.username.length).to be <= 20

        expect(user.email).to eq "deleted+#{user.username}@factlink.com"
      end

      command.call
    end
  end
end
