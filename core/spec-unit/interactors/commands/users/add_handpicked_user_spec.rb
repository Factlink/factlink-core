require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/add_handpicked_user'

describe Commands::Users::AddHandpickedUser do
  include PavlovSupport

  describe '#execute' do
    it 'calls a HandpickedTourUsers.add to add user' do
      stub_classes 'HandpickedTourUsers'
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
end
