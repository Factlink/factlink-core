require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_fact_relations'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingFactRelations do
  include PavlovSupport

  before do
    stub_classes 'SubComment'
  end

  describe '#call' do
    it 'uniques the follower ids' do
      fact_relations = [
        stub(id: 1,
             created_by_id: 1,
             opinionated_users_ids: 2
          ),
        stub(id: 2,
             created_by_id: 2,
             opinionated_users_ids: 3
          )
      ]
      sub_comments = [
        double( created_by: double( graph_user_id: 3 )),
        double( created_by: double( graph_user_id: 4 ))
      ]
      query = described_class.new fact_relations: fact_relations

      Pavlov.stub(:old_query)
            .with(:'sub_comments/index', fact_relations.map(&:id), 'FactRelation')
            .and_return(sub_comments)

      expect(query.call).to eq [1, 2, 3, 4]
    end
  end
end
