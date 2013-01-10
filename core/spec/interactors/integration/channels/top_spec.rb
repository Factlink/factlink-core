require 'spec_helper'

describe Interactors::Channels::Top do
  include Pavlov::Helpers

  let(:current_user) {create :user}

  def pavlov_options
    {current_user: current_user, ability: stub(:ability, can?: true)}
  end

  it 'should return "count" number of channels' do
    channel1 = create :channel
    interactor :'channels/add_fact', (create :fact), channel1

    channel2 = create :channel
    interactor :'channels/add_fact', (create :fact), channel2

    top_channels = TopChannels.new
    top_channels.add channel1.id
    top_channels.add channel2.id

    result = interactor :"channels/top", 1

    expect(result.length).to eq 1
    expect([channel1.id, channel2.id]).to include result[0].id
  end

  it 'should not return channels which do not exist' do
    channel1 = create :channel
    interactor :'channels/add_fact', (create :fact), channel1

    top_channels = TopChannels.new
    top_channels.add channel1.id

    channel1.delete

    result = interactor :"channels/top", 1

    expect(result.length).to eq 0
  end

  it "should not return channels without facts" do
    channel1 = create :channel

    top_channels = TopChannels.new
    top_channels.add channel1.id

    result = interactor :"channels/top", 1

    expect(result.length).to eq 0
  end

  it 'should not return "nil" channels' do
    channel1 = create :channel
    interactor :'channels/add_fact', (create :fact), channel1
    channel2 = create :channel
    interactor :'channels/add_fact', (create :fact), channel2

    top_channels = TopChannels.new
    top_channels.add channel1.id
    top_channels.add channel2.id

    channel1.delete

    result = interactor :"channels/top", 2

    expect(result.map(&:id)).to eq [channel2.id]
  end
end
