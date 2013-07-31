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

      command = described_class.new user_id

      command.execute
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      user_id = double

      described_class.any_instance.should_receive(:validate_hexadecimal_string)
                                  .with(:user_id, user_id)

      command = described_class.new user_id
    end
  end
end
