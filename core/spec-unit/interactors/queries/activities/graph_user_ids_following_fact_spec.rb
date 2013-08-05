require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_fact'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingFact do
  include PavlovSupport

  before do
    stub_classes 'Comment'
  end

  describe '#call' do
    it 'returns a unique list of ids' do
      fact = double :fact,
        created_by_id: 1,
        opinionated_users_ids: [2, 3],
        fact_relations: double,
        data_id: 133
      comments = double
      query = described_class.new fact: fact

      Comment.stub(:where)
             .with(fact_data_id: fact.data_id)
             .and_return(comments)
      Pavlov.stub(:old_query)
              .with(:"activities/graph_user_ids_following_comments", comments)
              .and_return([4,5])
      Pavlov.stub(:old_query)
              .with(:"activities/graph_user_ids_following_fact_relations", fact.fact_relations)
              .and_return [3, 4]

      expect(query.call).to eq [1, 2, 3, 4, 5]
    end
  end
end
