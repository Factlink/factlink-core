require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/interacting_users.rb'

describe Queries::Facts::InteractingUsers do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    it "returns a user who believes the fact" do
      user = mock(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user, id: 13)

      fact = mock id: 1, people_believes: [graph_user]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      query = described_class.new(1, 0, 3, 'believes')
      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "returns a user who disbelieves the fact" do
      user = mock(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user, id: 13)

      fact = mock id: 1, people_disbelieves: [graph_user]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      query = described_class.new(1, 0, 3, 'disbelieves')
      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "returns a user who doubts the fact" do
      user = mock(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user, id: 13)

      fact = mock id: 1, people_doubts: [graph_user]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      query = described_class.new(1, 0, 3, 'doubts')
      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "correctly skips and takes" do
      user1 = mock(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      user2 = mock(id: 3, username: 'my_username', name: 'Joop Bouwhuis' )
      user3 = mock(id: 4, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user1 = mock(user: user1, id: 13)
      graph_user2 = mock(user: user2, id: 14)
      graph_user3 = mock(user: user3, id: 15)

      fact = mock id: 1, people_believes: [graph_user1, graph_user2, graph_user3]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      pavlov_options = { current_user: mock(graph_user_id: 666) }

      query = described_class.new(1, 1, 1, 'believes', pavlov_options)
      result = query.call

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 1
      expect(result[:users].first.id).to eq user2.id
    end

    it "puts myself on front" do
      user1 = mock(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      user2 = mock(id: 3, username: 'my_username', name: 'Joop Bouwhuis' )
      user3 = mock(id: 4, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user1 = mock(user: user1, id: 14)
      graph_user2 = mock(user: user2, id: 15)
      user2.stub graph_user: graph_user2,
                 graph_user_id: graph_user2.id
      graph_user3 = mock(user: user3, id: 17)

      fact = mock id: 1, people_believes: [graph_user1, graph_user2, graph_user3]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      current_user = user2
      pavlov_options = {
        current_user: current_user
      }

      result = described_class.new(1, 0, 3, 'believes', pavlov_options).call

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 3
      expect(result[:users][0].id).to eq current_user.id
      expect(result[:users][1].id).to eq user1.id
      expect(result[:users][2].id).to eq user3.id
    end
  end
end
