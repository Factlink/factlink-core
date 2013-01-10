require 'spec_helper'

describe Interactors::Channels::Top do
  include Pavlov::Helpers

  let(:current_user) {create :user}

  def pavlov_options
    {current_user: current_user, ability: stub(:ability, can?: true)}
  end

  it 'should return "count" number of channels' do
    channel1 = create :channel
    channel2 = create :channel

    top_channels = TopChannels.new
    top_channels.add channel1.id
    top_channels.add channel2.id

    result = interactor :"channels/top", 1

    expect(result.length).to eq 1
  end

  it 'should not return "nil" channels' do
    channel1 = create :channel
    channel2 = create :channel

    top_channels = TopChannels.new
    top_channels.add channel1.id
    top_channels.add channel2.id

    channel1.delete

    result = interactor :"channels/top", 2

    expect(result.length).to eq 1
  end
end
