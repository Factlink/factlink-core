require 'spec_helper'

describe MoveAwaySubchannelsWithOtherTitle do
  include PavlovSupport

  let(:user1) {create :user}
  let(:user2) {create :user}
  let(:user3) {create :user}
  let(:user4) {create :user}
  let(:channel_user) {create :user}
  let(:fact1) {create :fact}
  let(:fact2) {create :fact}

  describe '#subchannels_with_other_title' do
    it "returns all subchannels which don't have the same title as the top channel" do
      channel, ch1, ch2, ch3, ch4 = ()

      as(user1) do |pavlov|
        ch1 = pavlov.command :'channels/create', 'Foo'
      end
      as(user2) do |pavlov|
        ch2 = pavlov.command :'channels/create', 'Bar'
      end
      as(user3) do |pavlov|
        ch3 = pavlov.command :'channels/create', 'Baz'
      end
      as(user4) do |pavlov|
        ch4 = pavlov.command :'channels/create', 'Foo'
      end
      as(channel_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'Foo'
        [ch1, ch2, ch3, ch4].each do |ch|
          pavlov.command 'channels/add_subchannel', channel, ch
        end
      end

      worker = MoveAwaySubchannelsWithOtherTitle.new(channel.id)

      subchannel_ids = worker.subchannels_with_other_title
                             .map(&:id)

      expect(subchannel_ids).to match_array [ch2.id, ch3.id]

    end
  end
  describe '#reassign_subchannel' do
    it 'follows a subchannel in a channel which has the same name, and removes from this one' do
      channel, ch1, ch2 = ()

      as(user1) do |pavlov|
        ch1 = pavlov.command :'channels/create', 'Foo'
      end
      as(user2) do |pavlov|
        ch2 = pavlov.command :'channels/create', 'Bar'
      end
      as(channel_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'Foo'
        [ch1, ch2].each do |ch|
          pavlov.command :'channels/add_subchannel', channel, ch
        end
      end

      worker = MoveAwaySubchannelsWithOtherTitle.new(channel.id)

      worker.reassign_subchannel ch2

      as(channel_user) do |pavlov|
        channel_bar = pavlov.query :'channels/get_by_slug_title', ch2.slug_title
        expect(channel_bar).not_to be_nil
        expect(channel_bar.contained_channels.ids).to match_array [ch2.id]

        expect(channel.contained_channels.ids).to match_array [ch1.id]
      end
    end

    it "moves facts" do
      old_channel, new_channel, subchannel = ()

      as(user1) do |pavlov|
        subchannel = pavlov.command :'channels/create', 'bar'
      end

      as(channel_user) do |pavlov|
        old_channel = pavlov.command :'channels/create', 'foo'
        new_channel = pavlov.command :'channels/create', 'bar'
        pavlov.command :'channels/add_subchannel', old_channel, subchannel
      end

      as(user1) do |pavlov|
        pavlov.interactor :'channels/add_fact', fact1, subchannel
      end

      worker = MoveAwaySubchannelsWithOtherTitle.new(old_channel.id)
      worker.reassign_subchannel subchannel

      as(channel_user) do |pavlov|
        old_facts = pavlov.interactor :'channels/facts', old_channel.id, nil, nil
        expect(old_facts).to match_array []

        new_facts = pavlov.interactor :'channels/facts', new_channel.id, nil, nil
        expect(new_facts[0][:item]).to   eq fact1
        expect(new_facts.size).to eq 1
      end
    end

    it "does not touch topics" do
      old_channel, new_channel, subchannel, old_foo_topics, old_bar_topics = ()

      as(user1) do |pavlov|
        subchannel = pavlov.command :'channels/create', 'bar'
      end

      as(channel_user) do |pavlov|
        old_channel = pavlov.command :'channels/create', 'foo'
        new_channel = pavlov.command :'channels/create', 'bar'
        pavlov.command :'channels/add_subchannel', old_channel, subchannel
      end

      as(user1) do |pavlov|
        pavlov.interactor :'channels/add_fact', fact1, subchannel
      end

      as(channel_user) do |pavlov|
        pavlov.interactor :'channels/add_fact', fact2, new_channel
        old_foo_topics = pavlov.interactor :'topics/facts', 'foo', nil, nil
        old_bar_topics = pavlov.interactor :'topics/facts', 'bar', nil, nil
      end

      worker = MoveAwaySubchannelsWithOtherTitle.new(old_channel.id)
      worker.reassign_subchannel subchannel

      as(channel_user) do |pavlov|
        new_foo_topics = pavlov.interactor :'topics/facts', 'foo', nil, nil
        expect(old_foo_topics).to match_array new_foo_topics

        new_bar_topics = pavlov.interactor :'topics/facts', 'bar', nil, nil
        expect(old_bar_topics).to match_array new_bar_topics
      end
    end
  end
  describe '#perform' do
    it "moves away all subchannels which don't belong here" do
      channel, ch1, ch2, ch3, ch4 = ()

      as(user1) do |pavlov|
        ch1 = pavlov.command :'channels/create', 'Foo'
      end
      as(user2) do |pavlov|
        ch2 = pavlov.command :'channels/create', 'Bar'
      end
      as(user3) do |pavlov|
        ch3 = pavlov.command :'channels/create', 'Baz'
      end
      as(user4) do |pavlov|
        ch4 = pavlov.command :'channels/create', 'Foo'
      end
      as(channel_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'Foo'
        pavlov.command :'channels/create', 'Bar'
        [ch1, ch2, ch3, ch4].each do |ch|
          pavlov.command 'channels/add_subchannel', channel, ch
        end
      end

      worker = MoveAwaySubchannelsWithOtherTitle.new(channel.id)
      worker.perform

      as(channel_user) do |pavlov|
        channel_bar = pavlov.query :'channels/get_by_slug_title', ch2.slug_title
        channel_baz = pavlov.query :'channels/get_by_slug_title', ch3.slug_title

        expect(channel_bar).not_to be_nil
        expect(channel_bar.contained_channels.ids).to match_array [ch2.id]

        expect(channel_baz).not_to be_nil
        expect(channel_baz.contained_channels.ids).to match_array [ch3.id]

        expect(channel.contained_channels.ids).to match_array [ch1.id, ch4.id]
      end
    end
  end
end
