require 'spec_helper'

describe Interactors::Channels::Top do
  include PavlovSupport

  let(:current_user) {create :user}

  it 'should return "count" number of channels' do
    as(current_user) do |pavlov|
      channel1 = pavlov.command :'channels/create', 'channel1'
      pavlov.interactor :'channels/add_fact', (create :fact), channel1

      channel2 = pavlov.command :'channels/create', 'channel2'
      pavlov.interactor :'channels/add_fact', (create :fact), channel2

      top_channels = TopChannels.new
      top_channels.add channel1.id
      top_channels.add channel2.id

      result = pavlov.interactor :"channels/top", 1

      expect(result.length).to eq 1
      expect([channel1.id, channel2.id]).to include result[0].id
    end
  end

  it 'should not return channels which do not exist' do
    as(current_user) do |pavlov|
      channel1 = pavlov.command :'channels/create', 'channel1'
      pavlov.interactor :'channels/add_fact', (create :fact), channel1

      top_channels = TopChannels.new
      top_channels.add channel1.id

      channel1.delete

      result = pavlov.interactor :"channels/top", 1

      expect(result.length).to eq 0
    end
  end

  it "should not return channels without facts" do
    as(current_user) do |pavlov|
      channel1 = pavlov.command :'channels/create', 'channel1'

      top_channels = TopChannels.new
      top_channels.add channel1.id

      result = pavlov.interactor :"channels/top", 1

      expect(result.length).to eq 0
    end
  end

  it 'should not return "nil" channels' do
    as(current_user) do |pavlov|
      channel1 = pavlov.command :'channels/create', 'channel1'
      pavlov.interactor :'channels/add_fact', (create :fact), channel1
      channel2 = pavlov.command :'channels/create', 'channel2'
      pavlov.interactor :'channels/add_fact', (create :fact), channel2

      top_channels = TopChannels.new
      top_channels.add channel1.id
      top_channels.add channel2.id

      channel1.delete

      result = pavlov.interactor :"channels/top", 2

      expect(result.map(&:id)).to eq [channel2.id]
    end
  end
end
