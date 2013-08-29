require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/interacting_users.rb'

describe Queries::Facts::InteractingUsers do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    it 'returns a user who believes the fact' do
      user = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = double(user: user, id: 13)
      fact = double(id: 1, people_believes: [graph_user])
      query = described_class.new(fact_id: fact.id, skip: 0, take: 3,
        opinion: 'believes')

      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it 'returns a user who disbelieves the fact' do
      user = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = double(user: user, id: 13)
      fact = double id: 1, people_disbelieves: [graph_user]
      query = described_class.new(fact_id: fact.id, skip: 0, take: 3,
        opinion: 'disbelieves')

      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it 'returns a user who doubts the fact' do
      user = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = double(user: user, id: 13)
      fact = double(id: 1, people_doubts: [graph_user])
      query = described_class.new(fact_id: fact.id, skip: 0, take: 3,
        opinion: 'doubts')

      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it 'correctly skips and takes' do
      user1 = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      user2 = double(id: 3, username: 'my_username', name: 'Joop Bouwhuis' )
      user3 = double(id: 4, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user1 = double(user: user1, id: 13)
      graph_user2 = double(user: user2, id: 14)
      graph_user3 = double(user: user3, id: 15)
      fact = double id: 1, people_believes: [graph_user1, graph_user2, graph_user3]
      pavlov_options = { current_user: double(graph_user_id: 666) }
      query = described_class.new(fact_id: 1, skip: 1, take: 1,
        opinion: 'believes', pavlov_options: pavlov_options)

      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = query.call

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 1
      expect(result[:users].first.id).to eq user2.id
    end

    it 'puts myself on front' do
      user1 = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      user2 = double(id: 3, username: 'my_username', name: 'Joop Bouwhuis' )
      user3 = double(id: 4, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user1 = double(user: user1, id: 14)
      graph_user2 = double(user: user2, id: 15)
      user2.stub graph_user: graph_user2,
                 graph_user_id: graph_user2.id
      graph_user3 = double(user: user3, id: 17)
      fact = double id: 1, people_believes: [graph_user1, graph_user2, graph_user3]
      current_user = user2
      pavlov_options = {
        current_user: current_user
      }
      query = described_class.new(fact_id: 1, skip: 0, take: 3,
        opinion: 'believes', pavlov_options: pavlov_options)

      Fact.stub(:[]).with(fact.id).and_return(fact)

      result = query.call

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 3
      expect(result[:users][0].id).to eq current_user.id
      expect(result[:users][1].id).to eq user1.id
      expect(result[:users][2].id).to eq user3.id
    end
  end
end
