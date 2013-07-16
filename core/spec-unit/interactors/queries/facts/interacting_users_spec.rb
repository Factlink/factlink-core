require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/interacting_users.rb'

describe Queries::Facts::InteractingUsers do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '.call' do
    it "returns a user who believes the fact" do
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user)

      fact = mock id: 1, people_believes: [graph_user]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = described_class.new(1, 0, 3, 'believes').call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "returns a user who disbelieves the fact" do
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user)

      fact = mock id: 1, people_disbelieves: [graph_user]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = described_class.new(1, 0, 3, 'disbelieves').call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "returns a user who doubts the fact" do
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user)

      fact = mock id: 1, people_doubts: [graph_user]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = described_class.new(1, 0, 3, 'doubts').call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "correctly skips and takes" do
      user1 = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      user2 = mock(id: 3, username: 'mijn username', name: 'Joop Bouwhuis' )
      user3 = mock(id: 4, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user1 = mock(user: user1)
      graph_user2 = mock(user: user2)
      graph_user3 = mock(user: user3)

      fact = mock id: 1, people_believes: [graph_user1, graph_user2, graph_user3]
      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = described_class.new(1, 1, 1, 'believes').call

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 1
      expect(result[:users].first.id).to eq user2.id
    end
  end
end
