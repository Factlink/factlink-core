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

      query.should_receive(:creator_ids).and_return(creator_ids)
      query.should_receive(:opinionated_users_ids).and_return(opinionated_users_ids)
      query.should_receive(:evidence_followers_ids).and_return(evidence_followers_ids)

      expect(query.execute).to eq [1, 2, 3, 4]
    end
  end
end
