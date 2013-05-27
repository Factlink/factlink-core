require_relative '../../../../app/interactors/queries/users/handpicked'
require 'pavlov_helper'

describe Queries::Users::Handpicked do
  include PavlovSupport

  describe '.execute' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
      stub_classes 'HandpickedTourUsers'
    end

    it 'should return the non_dead_handpicked_users' do
      users = mock
      HandpickedTourUsers.should_receive(:new).and_return (stub members: users)

      query = described_class.new {}

      expect(query.execute).to eq users
    end
  end

end
