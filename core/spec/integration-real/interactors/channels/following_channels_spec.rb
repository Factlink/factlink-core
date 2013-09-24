require 'spec_helper'

describe 'following a channel' do
  include PavlovSupport

  let(:current_user) { create :active_user }
  let(:other_user)   { create :active_user }
  let(:third_user)   { create :active_user }

  it "creating a channel" do
    as current_user do |pavlov|
      pavlov.command :'channels/create', title: 'Foo'

      channel = pavlov.query :'channels/get_by_slug_title', slug_title: 'foo'

      expect(channel.title).to eq 'Foo'
    end
  end

  it "adding a subchannel" do
    ch1, ch2, sub_ch = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.command :'channels/create', title: 'Foo'
      ch2 = pavlov.command :'channels/create', title: 'Bar'
    end

    as(current_user) do |pavlov|
      sub_ch = pavlov.command :'channels/create', title: 'Foo'
    end

    as(other_user) do |pavlov|
      pavlov.interactor :'channels/add_subchannel', channel_id: ch1.id, subchannel_id: sub_ch.id
    end

    as(current_user) do |pavlov|
      sub_channels = pavlov.interactor :'channels/sub_channels', channel: ch1
      sub_channels.map(&:id).should =~ [sub_ch.id]
    end
  end

  it "following a channel" do
    ch1, ch2 = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.command :'channels/create', title: 'Foo'
      ch2 = pavlov.command :'channels/create', title: 'Bar'
    end

    as current_user do |pavlov|
      sub_ch = pavlov.command :'channels/create', title: 'Foo'

      pavlov.interactor :'channels/follow', channel_id: ch1.id
      pavlov.interactor :'channels/follow', channel_id: ch2.id

      channels = pavlov.interactor :'channels/visible_of_user_for_user', user: current_user
      channels.map(&:title).should =~ ['Foo', 'Bar']

      sub_channels = pavlov.interactor :'channels/sub_channels', channel: sub_ch
      sub_channels.map(&:id).should =~ [ch1.id]

      bar_ch = pavlov.query :'channels/get_by_slug_title', slug_title: 'bar'
      sub_channels = pavlov.interactor :'channels/sub_channels', channel: bar_ch
      sub_channels.map(&:id).should =~ [ch2.id]
    end
  end

  it "unfollowing a channel" do
    other_user.graph_user.id
    ch1,third_ch = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.command :'channels/create', title: 'Foo'
    end

    as(current_user) do |pavlov|
      pavlov.interactor :'channels/follow', channel_id: ch1.id
    end

    as(third_user) do |pavlov|
      third_ch = pavlov.command :'channels/create', title: 'Bar'
      pavlov.interactor :'channels/add_subchannel', channel_id: third_ch.id, subchannel_id: ch1.id
    end

    as(current_user) do |pavlov|
      pavlov.interactor :'channels/unfollow', channel_id: ch1.id
    end

    as(other_user) do |pavlov|
      foo_ch = pavlov.query :'channels/get_by_slug_title', slug_title: 'foo'
      foo_ch.containing_channels.ids.should =~ [third_ch.id]
    end
  end

  it "following a channel favourites the topic" do
    ch1= ()

    as(other_user) do |pavlov|
      ch1 = pavlov.command :'channels/create', title: 'Foo'
    end

    as current_user do |pavlov|
      pavlov.interactor :'channels/follow', channel_id: ch1.id

      favourites = pavlov.interactor :'topics/favourites', user_name: current_user.username
      favourites_slugs = favourites.map(&:slug_title)
      expect(favourites_slugs).to match_array [ch1.slug_title]
    end
  end
end
