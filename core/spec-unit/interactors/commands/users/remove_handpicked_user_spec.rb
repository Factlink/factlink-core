require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/remove_handpicked_user'

describe Commands::Users::RemoveHandpickedUser do
  include PavlovSupport

  describe '#execute' do
    it 'calls a HandpickedTourUsers.remove to remove user' do
      stub_classes 'HandpickedTourUsers'
      user_id = double
      handpicked_tour_users = double

      HandpickedTourUsers.stub(:new)
                        .and_return(handpicked_tour_users)

      handpicked_tour_users.should_receive(:remove)
                           .with(user_id)

      command = described_class.new user_id: user_id

      command.execute
    end
  end
end
