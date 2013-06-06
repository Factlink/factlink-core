require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_fact_relations'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingFactRelations do
  include PavlovSupport

  describe '#call' do
    it 'uniques the follower ids' do
      ids = [1, 2, 3]
      follower_ids = [1, 2, 2, 2, 2, 3]

      query = described_class.new mock

      query.should_receive(:follower_ids)
              .and_return(follower_ids)
      follower_ids.should_receive(:uniq)
                      .and_return(ids)

      expect(query.call).to eq ids
    end
  end

  describe '#follower_ids' do
    it 'combines the ids of all followers' do
      fact_relations_creators_ids = [1, 2]
      fact_relations_opinionated_ids = [2, 3]
      sub_comments_on_fact_relations_creators_ids = [3, 4]

      query = described_class.new mock

      query.should_receive(:fact_relations_creators_ids)
              .and_return(fact_relations_creators_ids)
      query.should_receive(:fact_relations_opinionated_ids)
              .and_return(fact_relations_opinionated_ids)
      query.should_receive(:sub_comments_on_fact_relations_creators_ids)
              .and_return(sub_comments_on_fact_relations_creators_ids)

      expect(query.follower_ids).to eq [1, 2, 2, 3, 3, 4]
    end
  end

  describe '#fact_relations_creators_ids' do
    it 'returns ids of the comment creator' do
      fact_relations = [stub(created_by_id: 42)]

      query = described_class.new fact_relations

      expect(query.fact_relations_creators_ids).to eq [42]
    end
  end

  describe '#fact_relations_opinionated_ids' do
    it 'returns ids of the comment opinionators' do
      fact_relations = [stub(opinionated_users_ids: 44),
                        stub(opinionated_users_ids: 55)]

      query = described_class.new fact_relations

      expect(query.fact_relations_opinionated_ids).to eq [44, 55]
    end
  end

  describe '#sub_comments_on_fact_relations_creators_ids' do
    it 'returns ids of creators of subcomments of the fact_relation' do
      stub_classes 'SubComment'

      finder = mock

      fact_relations = [
        mock( id: '1' ),
        mock( id: '2' )
      ]

      sub_comments = [
        mock( created_by: mock( graph_user_id: 5 )),
        mock( created_by: mock( graph_user_id: 6 ))
      ]

      query = described_class.new fact_relations

      query.should_receive(:fact_relations_ids)
              .and_return(fact_relations.map(&:id))

      SubComment.should_receive(:where)
                  .with(parent_class: 'FactRelation')
                  .and_return(finder)

      finder.should_receive(:any_in)
                  .with(parent_id: fact_relations.map(&:id))
                  .and_return(sub_comments)

      expect(query.sub_comments_on_fact_relations_creators_ids).to eq [5, 6]
    end
  end

  describe '#fact_relations_ids' do
    it 'returns the fact_relations ids' do
      fact_relations = [stub(id: 73), stub(id: 74)]

      query = described_class.new fact_relations

      expect(query.fact_relations_ids).to eq [73, 74]
    end
  end
end
