require 'spec_helper'

describe 'following a channel' do
  include PavlovSupport

  let(:current_user) {create :user}
  let(:other_user)   {create :user}
  let(:third_user)   {create :user}

  it "creating a channel" do
    as current_user do |pavlov|
      pavlov.old_command :'channels/create', 'Foo'

      channel = pavlov.old_query :'channels/get_by_slug_title', 'foo'

      expect(channel.title).to eq 'Foo'
    end
  end

  it "adding a subchannel" do
    ch1, ch2, sub_ch = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.old_command :'channels/create', 'Foo'
      ch2 = pavlov.old_command :'channels/create', 'Bar'
    end

    as(current_user) do |pavlov|
      sub_ch = pavlov.old_command :'channels/create', 'Foo'
    end

    as(other_user) do |pavlov|
      pavlov.old_interactor :'channels/add_subchannel', ch1.id, sub_ch.id
    end

    as(current_user) do |pavlov|
      sub_channels = pavlov.old_interactor :'channels/sub_channels', ch1
      sub_channels.map(&:id).should =~ [sub_ch.id]
    end
  end

  it "following a channel" do
    ch1, ch2 = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.old_command :'channels/create', 'Foo'
      ch2 = pavlov.old_command :'channels/create', 'Bar'
    end

    as current_user do |pavlov|
      sub_ch = pavlov.old_command :'channels/create', 'Foo'

      pavlov.old_interactor :'channels/follow', ch1.id
      pavlov.old_interactor :'channels/follow', ch2.id

      channels = pavlov.old_interactor :'channels/visible_of_user_for_user', current_user
      channels.map(&:title).should =~ ['Foo', 'Bar']

      sub_channels = pavlov.old_interactor :'channels/sub_channels', sub_ch
      sub_channels.map(&:id).should =~ [ch1.id]

      bar_ch = pavlov.old_query :'channels/get_by_slug_title', 'bar'
      sub_channels = pavlov.old_interactor :'channels/sub_channels', bar_ch
      sub_channels.map(&:id).should =~ [ch2.id]
    end
  end

  it "unfollowing a channel" do
    other_user.graph_user.id
    ch1,third_ch = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.old_command :'channels/create', 'Foo'
    end

    as(current_user) do |pavlov|
      pavlov.old_interactor :'channels/follow', ch1.id
    end

    as(third_user) do |pavlov|
      third_ch = pavlov.old_command :'channels/create', 'Bar'
      pavlov.old_interactor :'channels/add_subchannel', third_ch.id, ch1.id
    end

    as(current_user) do |pavlov|
      pavlov.old_interactor :'channels/unfollow', ch1.id
    end

    as(other_user) do |pavlov|
      foo_ch = pavlov.old_query :'channels/get_by_slug_title', 'foo'
      foo_ch.containing_channels.ids.should =~ [third_ch.id]
    end
  end

  it "following a channel favourites the topic" do
    ch1= ()

    as(other_user) do |pavlov|
      ch1 = pavlov.old_command :'channels/create', 'Foo'
    end

    as current_user do |pavlov|
      pavlov.old_interactor :'channels/follow', ch1.id

      favourites = pavlov.old_interactor :'topics/favourites', current_user.username
      favourites_slugs = favourites.map(&:slug_title)
      expect(favourites_slugs).to match_array [ch1.slug_title]
    end
  end
end
