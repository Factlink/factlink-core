require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/opinionators.rb'

describe Queries::Facts::Opinionators do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    it 'returns a user who believes the fact' do
      user = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = double(user: user, id: 13)
      fact = double(id: 1)
      query = described_class.new(fact_id: fact.id, skip: 0, take: 3,
                                  opinion: 'believes')

      Fact.stub(:[]).with(fact.id).and_return(fact)
      fact.stub(:opiniated).with('believes').and_return([graph_user])

      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it 'returns a user who disbelieves the fact' do
      user = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = double(user: user, id: 13)
      fact = double(id: 1)
      query = described_class.new(fact_id: fact.id, skip: 0, take: 3,
                                  opinion: 'disbelieves')

      Fact.stub(:[]).with(fact.id).and_return(fact)
      fact.stub(:opiniated).with('disbelieves').and_return([graph_user])

      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it 'returns a user who doubts the fact' do
      user = double(id: 2, username: 'my_username', name: 'Joop Bouwhuis' )
      graph_user = double(user: user, id: 13)
      fact = double(id: 1)
      query = described_class.new(fact_id: fact.id, skip: 0, take: 3,
                                  opinion: 'doubts')

      Fact.stub(:[]).with(fact.id).and_return(fact)
      fact.stub(:opiniated).with('doubts').and_return([graph_user])

      result = query.call

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end
  end
end
