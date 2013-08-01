require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/add_handpicked_user'

describe Commands::Users::AddHandpickedUser do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub validate: true
      stub_classes 'HandpickedTourUsers'
    end

    it 'calls a HandpickedTourUsers.add to add user' do
      user_id = double
      handpicked_tour_users = double

      HandpickedTourUsers.stub(:new)
                        .and_return(handpicked_tour_users)

      handpicked_tour_users.should_receive(:add)
                           .with(user_id)

      command = described_class.new user_id: user_id

      command.execute
    end
  end

  describe 'validations' do
    it 'requires valid user_id' do
      expect_validating(fact_id: '').
        to fail_validation('user_id should be an hexadecimal string.')
    end
  end
end
