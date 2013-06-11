require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_fact'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingFact do
  include PavlovSupport

  before do
    stub_classes 'Comment'
  end

  describe '#call' do
    it 'returns a unique list of ids' do
      fact = mock :fact,
        created_by_id: 1,
        opinionated_users_ids: [2, 3]

      query = described_class.new fact

      query.stub(:fact_relations_followers_ids)
              .and_return( [3, 4] )
      query.stub(:comments_followers_ids)
              .and_return( [4, 5] )

      expect(query.call).to eq [1, 2, 3, 4, 5]
    end
  end

  describe '#fact_relations_follower_ids' do
    it 'calls the correct query' do
      fact = mock
      query = described_class.new fact
      fact.stub fact_relations: mock

      query.should_receive(:query)
              .with(:"activities/graph_user_ids_following_fact_relations", fact.fact_relations)
              .and_return [1,2]

      expect(query.fact_relations_followers_ids).to eq [1,2]
    end
  end

  describe '#comment_followers_ids' do
    it 'calls the correct query' do
      fact = stub data_id: 133
      comments = mock
      comment_followers_ids = mock

      query = described_class.new fact

      Comment.stub(:where)
             .with(fact_data_id: fact.data_id)
             .and_return(comments)

      query.stub(:query)
              .with(:"activities/graph_user_ids_following_comments", comments)
              .and_return(comment_followers_ids)

      expect(query.comments_followers_ids).to eq comment_followers_ids
    end
  end
end
