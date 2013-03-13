require 'spec_helper'

describe 'following a channel' do
  include PavlovSupport

  let(:current_user) {create :user}
  let(:other_user)   {create :user}

  it "creating a channel" do
    as current_user do |pavlov|
      pavlov.command 'channels/create', 'Foo'

      channel = pavlov.query 'channels/get_by_slug_title', 'foo'

      expect(channel.title).to eq 'Foo'
    end
  end

  it "adding a subchannel" do
    ch1, ch2, sub_ch = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.command 'channels/create', 'Foo'
      ch2 = pavlov.command 'channels/create', 'Bar'
    end

    as(current_user) do |pavlov|
      sub_ch = pavlov.command 'channels/create', 'Foo'
    end

    as(other_user) do |pavlov|
      pavlov.interactor 'channels/add_subchannel', ch1.id, sub_ch.id
    end

    as(current_user) do |pavlov|
      sub_channels = pavlov.interactor 'channels/sub_channels', ch1
      sub_channels.map(&:id).should =~ [sub_ch.id]
    end
  end

  it "following a channel" do
    ch1, ch2 = ()

    as(other_user) do |pavlov|
      ch1 = pavlov.command 'channels/create', 'Foo'
      ch2 = pavlov.command 'channels/create', 'Bar'
    end

    as current_user do |pavlov|
      sub_ch = pavlov.command 'channels/create', 'Foo'

      pavlov.interactor 'channels/follow', ch1.id
      pavlov.interactor 'channels/follow', ch2.id

      channels = pavlov.interactor 'channels/visible_of_user_for_user', current_user
      channels.map(&:title).should =~ ['Foo', 'Bar']

      sub_channels = pavlov.interactor 'channels/sub_channels', sub_ch
      sub_channels.map(&:id).should =~ [ch1.id]

      bar_ch = pavlov.query 'channels/get_by_slug_title', 'bar'
      sub_channels = pavlov.interactor 'channels/sub_channels', bar_ch
      sub_channels.map(&:id).should =~ [ch2.id]
    end
  end
end
