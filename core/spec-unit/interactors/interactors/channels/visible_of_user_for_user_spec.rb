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

      Interactors::Channels::VisibleOfUserForUser.any_instance.stub(authorized?: true)
      query = Interactors::Channels::VisibleOfUserForUser.new user

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
      visible_channels = [mock(:ch1), mock(:ch2)]
      authorities = [mock(:a1), mock(:a2)]

      Interactors::Channels::VisibleOfUserForUser.any_instance.stub(authorized?: true)
      interactor = Interactors::Channels::VisibleOfUserForUser.new mock
      interactor.stub(visible_channels: visible_channels)

      interactor.should_receive(:old_query).
                 with(:creator_authorities_for_channels, visible_channels).
                 and_return(authorities)

      result = interactor.channels_with_authorities

      expect(result).to eq [
        [visible_channels[0],authorities[0]],
        [visible_channels[1],authorities[1]]
      ]
    end
  end

  describe ".authorized?" do
    it "initiating raises when the currently ability doesn't enable indexing channels" do
      ability = double
      ability.should_receive(:can?).with(:index, Channel).and_return(false)
      expect do
        interactor = Interactors::Channels::VisibleOfUserForUser.new mock, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end

    it "does not raise when initiating when the ability is enabled" do
      ability = double
      ability.should_receive(:can?).with(:index, Channel).and_return(true)
      expect do
        interactor = Interactors::Channels::VisibleOfUserForUser.new mock, ability: ability
      end.not_to raise_error
    end
  end
end
