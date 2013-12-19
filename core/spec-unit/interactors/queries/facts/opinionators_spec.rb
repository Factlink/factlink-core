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
      query = described_class.new(fact_id: fact.id, opinion: 'believes')

      Fact.stub(:[]).with(fact.id).and_return(fact)
      fact.stub(:opiniated).with('believes').and_return([graph_user])

      result = query.call

      expect(result.length).to eq 1
      expect(result[0].id).to eq user.id
    end
  end
end
