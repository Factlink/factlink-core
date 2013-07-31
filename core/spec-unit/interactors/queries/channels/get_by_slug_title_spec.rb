require_relative '../../../../app/interactors/queries/channels/get_by_slug_title'
require 'pavlov_helper'

describe Queries::Channels::GetBySlugTitle do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes('Channel')
    end

    it 'correctly' do
      channel = mock slug_title:'foo'
      channel_set = mock first: channel
      current_user = mock :current_user, graph_user_id: 10

      query = Queries::Channels::GetBySlugTitle.new channel.slug_title, current_user: current_user

      Channel.should_receive(:find)
             .with(:slug_title => 'foo', :created_by_id => 10)
             .and_return(channel_set)

      query.execute.should eq channel
    end
  end
end
