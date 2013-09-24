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
        expect(user.email).to eq 'deleted@factlink.com'
        expect(user.location).to eq ''
        expect(user.biography).to eq ''
        expect(user.identities['twitter']).to eq nil
        expect(user.identities['facebook']).to eq nil
      end

      command.call
    end

    it 'generates some anonymous username' do
      user = OpenStruct.new id: '1a', username: 'username'
      command = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return user

      expect(user).to receive(:save!) do
        expect(user.username).to include('anonymous')
      end

      command.call
    end
  end
end
