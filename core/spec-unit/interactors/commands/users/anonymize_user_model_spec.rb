require 'pavlov_helper'
require 'ostruct'
require_relative '../../../../app/interactors/commands/users/anonymize_user_model'

describe Commands::Users::AnonymizeUserModel do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'User'
    end

    it 'anonymizes fields of the user that contains personal data' do
      user = OpenStruct.new id: '1a'
      command = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return user

      expect(user).to receive(:save!)

      command.call
    end
  end
end
