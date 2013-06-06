require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/update_user_authority'

describe Commands::Topics::UpdateUserAuthority do
  include PavlovSupport

  before do
    stub_classes 'Authority', 'GraphUser'
  end

  describe '#call' do
    it 'updates the authority' do
      graph_user = mock id: '12'
      topic = mock id: 'a5', slug_title: 'foo'
      authority = 15

      authority_object = mock


      query = described_class.new graph_user.id, topic.slug_title, authority

      GraphUser.stub(:[]).with(graph_user.id)
               .and_return(graph_user)

      Pavlov.stub(:query)
            .with(:'topics/by_slug_title', topic.slug_title)
            .and_return(topic)

      Authority.stub(:from).with(topic, for: graph_user)
               .and_return authority_object

      authority_object.should_receive(:<<)
                      .with(authority)

      query.call
    end
  end

end
