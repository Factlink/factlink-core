require 'spec_helper'

describe 'following a channel' do
  include PavlovSupport

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }

  let(:current_user) {create :user, graph_user: u1}
  let(:other_user)   {create :user, graph_user: u2}


  it "creating a channel" do
    channel = nil
    as_user current_user do |p|
      p.command 'channels/create', 'Foo'

      channel = p.query 'channels/get_by_slug_title', 'foo'
      expect(channel.title).to eq 'Foo'
    end
  end

  it "adding a subchannel" do
    as_user current_user do |p|
      ch1 = create :channel, title: "Foo", created_by: other_user.graph_user
      ch2 = create :channel, title: "Bar", created_by: other_user.graph_user

      sub_ch = p.command 'channels/create', 'Foo'

      p.interactor 'channels/add_subchannel', ch1.id, sub_ch.id

      sub_channels = p.interactor 'channels/sub_channels', ch1
      sub_channels.map(&:id).should =~ [sub_ch.id]
    end
  end

  it "following a channel" do
    as_user current_user do |p|
      ch1 = create :channel, title: "Foo", created_by: other_user.graph_user
      ch2 = create :channel, title: "Bar", created_by: other_user.graph_user

      sub_ch = p.command 'channels/create', 'Foo'

      p.interactor 'channels/follow', ch1.id
      p.interactor 'channels/follow', ch2.id

      channels = p.interactor 'channels/visible_of_user_for_user', current_user
      channels.map(&:title).should =~ ['Foo', 'Bar']

      sub_channels = p.interactor 'channels/sub_channels', sub_ch
      sub_channels.map(&:id).should =~ [ch1.id]

      bar_ch = p.query 'channels/get_by_slug_title', 'bar'
      sub_channels = p.interactor 'channels/sub_channels', bar_ch
      sub_channels.map(&:id).should =~ [ch2.id]
    end
  end
end
