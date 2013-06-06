#graph_user_ids_following_fact_spec.rb
require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_fact'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingFact do
  include PavlovSupport

  describe '#call' do
    it 'returns a unique list of ids' do
      creator_ids = [1, 2]
      opinionated_users_ids = [2, 3]
      evidence_followers_ids = [3, 4]

      query = described_class.new mock

      query.should_receive(:creator_ids)
              .and_return(creator_ids)
      query.should_receive(:opinionated_users_ids)
              .and_return(opinionated_users_ids)
      query.should_receive(:evidence_followers_ids)
              .and_return(evidence_followers_ids)

      expect(query.call).to eq [1, 2, 3, 4]
    end
  end

  describe '#creator_ids' do
    it 'returns the Facts creator id' do
      fact = mock
      created_by_id = 1

      fact.should_receive(:created_by_id).and_return(created_by_id)

      query = described_class.new fact

      expect(query.creator_ids).to eq [created_by_id]
    end
  end

  describe '#opinionated_users_ids' do
    it 'calls the correct method' do
      fact = mock
      ids = mock

      query = described_class.new fact

      fact.should_receive(:opinionated_users_ids).and_return(ids)

      expect(query.opinionated_users_ids).to eq ids
    end
  end

  describe '#evidence_followers_ids' do
    it 'returns combined ids of fact_relation_followers and comments_followers_ids' do
      query = described_class.new mock

      query.should_receive(:fact_relations_followers_ids)
              .and_return( [1] )
      query.should_receive(:comments_followers_ids)
              .and_return( [2] )

      expect(query.evidence_followers_ids).to eq [1, 2]
    end
  end

  describe '#fact_relations_followers_ids' do
    it 'calls the correct query' do
      fact = mock
      query = described_class.new fact

      fact.should_receive(:fact_relations)

      query.fact_relations
    end
  end

  describe '#fact_relations' do
    it 'calls the correct query' do
      fact_relations = mock
      query = described_class.new mock

      query.should_receive(:fact_relations).and_return(fact_relations)
      query.should_receive(:query)
              .with(:"activities/graph_user_ids_following_fact_relations", fact_relations)

      query.fact_relations_followers_ids
    end
  end

  describe '#comment_followers_ids' do
    it 'calls the correct query' do
      comments = mock
      comment_followers_ids = mock

      query = described_class.new mock

      query.should_receive(:comments).and_return(comments)
      query.should_receive(:query)
              .with(:"activities/graph_user_ids_following_comments", comments)
              .and_return(comment_followers_ids)

      expect(query.comments_followers_ids).to eq comment_followers_ids
    end
  end

  describe '#comment' do
    it 'calls the correct query' do
      stub_classes 'Comment'
      comments = mock
      fact = stub data_id: 133

      query = described_class.new fact

      Comment.should_receive(:where)
                .with(fact_data_id: fact.data_id)
                .and_return(comments)

      expect(query.comments).to eq comments
    end
  end

end
