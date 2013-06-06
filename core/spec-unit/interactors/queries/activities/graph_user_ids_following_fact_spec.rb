#graph_user_ids_following_fact_spec.rb
require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_fact'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingFact do
  include PavlovSupport

  describe '#execute' do

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

      expect(query.execute).to eq [1, 2, 3, 4]
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

end
