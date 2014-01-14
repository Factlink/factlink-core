require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/opinionators.rb'

describe Queries::Facts::Opinionators do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    it 'returns a user who believes the fact' do
      user = double(id: 2, graph_user_id: 3, username: 'my_username', name: 'Joop Bouwhuis' )
      opinionator_ids = [user.graph_user_id]
      fact = double(id: 1)
      query = described_class.new(fact: fact, type: 'believes')

      fact.stub(:opiniated)
          .with('believes')
          .and_return double(ids: opinionator_ids)

      Pavlov.stub(:query)
            .with(:users_by_ids, user_ids: opinionator_ids, by: :graph_user_id)
            .and_return [user]

      result = query.call

      expect(result.length).to eq 1
      expect(result[0].id).to eq user.id
    end
  end
end
