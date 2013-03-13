require 'spec_helper'

describe 'following a channel' do
  include Pavlov::Helpers

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }

  let(:current_user) {create :user, graph_user: u1}
  let(:other_user)   {create :user, graph_user: u2}

  def pavlov_options
    {current_user: current_user, ability: stub(:ability, can?: true)}
  end

  it "creating a channel" do
    command 'channels/create', 'Foo'

    channel = query 'channels/get_by_slug_title', 'foo'

    expect(channel.title).to eq 'Foo'
  end

  it "adding a subchannel" do
    ch1 = create :channel, title: "Foo", created_by: other_user.graph_user
    ch2 = create :channel, title: "Bar", created_by: other_user.graph_user

    sub_ch = command 'channels/create', 'Foo'

    interactor 'channels/add_subchannel', ch1.id, sub_ch.id

    sub_channels = interactor 'channels/sub_channels', ch1
    sub_channels.map(&:id).should =~ [sub_ch.id]
  end

  it "following a channel" do
    ch1 = create :channel, title: "Foo", created_by: other_user.graph_user
    ch2 = create :channel, title: "Bar", created_by: other_user.graph_user

    sub_ch = command 'channels/create', 'Foo'

    interactor 'channels/follow', ch1.id
    interactor 'channels/follow', ch2.id

    channels = interactor 'channels/visible_of_user_for_user', current_user
    channels.map(&:title).should =~ ['Foo', 'Bar']

    sub_channels = interactor 'channels/sub_channels', sub_ch
    sub_channels.map(&:id).should =~ [ch1.id]

    bar_ch = query 'channels/get_by_slug_title', 'bar'
    sub_channels = interactor 'channels/sub_channels', bar_ch
    sub_channels.map(&:id).should =~ [ch2.id]
  end
end
