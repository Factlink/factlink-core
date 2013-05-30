require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/handpicked'

describe Queries::Users::Handpicked do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
      stub_classes 'HandpickedTourUsers', 'KillObject'
    end

    it 'should return the dead handpicked_users' do
      user1 = mock
      user2 = mock
      dead_user1 = mock
      dead_user2 = mock

      HandpickedTourUsers.stub(:new).and_return stub(members: [user1, user2])
      KillObject.stub(:user).with(user1).and_return(dead_user1)
      KillObject.stub(:user).with(user2).and_return(dead_user2)

      query = described_class.new

      expect(query.execute).to match_array [dead_user1, dead_user2]
    end
  end

end
