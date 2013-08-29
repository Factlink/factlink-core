require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/visible_of_user_for_user.rb'

describe Interactors::Channels::VisibleOfUserForUser do
  include PavlovSupport
  before do
    stub_classes 'Channel'
  end
  describe '#call' do
    it do
      user = double
      ch1 = double
      ch2 = double
      topic_authority = double
      containing_channels = double

      described_class.any_instance.stub authorized?: true
      query = described_class.new user: user

      query.stub(
        channels_with_authorities: [[ch1, topic_authority], [ch2, topic_authority]],
        containing_channel_ids: containing_channels
      )

      query.should_receive(:kill_channel).with(ch1, topic_authority, containing_channels, user)
      query.should_receive(:kill_channel).with(ch2, topic_authority, containing_channels, user)
      query.call
    end
  end

  describe ".channels_with_authorities" do
    it "combines the list of channels with the list of authorities" do
      visible_channels = [double(:ch1), double(:ch2)]
      authorities = [double(:a1), double(:a2)]

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new user: double
      interactor.stub(visible_channels: visible_channels)

      Pavlov.should_receive(:query)
            .with(:'creator_authorities_for_channels',
                      channels: visible_channels)
            .and_return(authorities)

      result = interactor.channels_with_authorities

      expect(result).to eq [
        [visible_channels[0],authorities[0]],
        [visible_channels[1],authorities[1]]
      ]
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
