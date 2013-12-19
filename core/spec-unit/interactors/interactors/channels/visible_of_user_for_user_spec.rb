require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/visible_of_user_for_user.rb'

describe Interactors::Channels::VisibleOfUserForUser do
  include PavlovSupport
  before do
    stub_classes 'Channel', 'KillObject'
  end
  describe '#call' do
    it do
      user_id = '1'
      user = double(graph_user: double(user_id: user_id))
      dead_user = double
      channel1 = double
      channel2 = double
      dead_channel1 = double
      dead_channel2 = double

      described_class.any_instance.stub authorized?: true
      query = described_class.new user: user

      Pavlov.stub(:query).with(:users_by_ids, user_ids: [user_id]).and_return([dead_user])

      query.stub visible_channels: [channel1, channel2]
      KillObject.stub(:channel).with(channel1)
        .and_return(dead_channel1)
      KillObject.stub(:channel).with(channel2)
        .and_return(dead_channel2)

      expect(query.call).to eq [dead_channel1, dead_channel2]
    end
  end

  describe ".authorized?" do
    it "raises AccessDenied when the currently ability doesn't enable indexing channels" do
      ability = double
      ability.stub(:can?)
             .with(:index, Channel)
             .and_return(false)

      interactor = described_class.new user: double,
                                       pavlov_options: { ability:ability }

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end
end
