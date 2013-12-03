require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/user_topics/last_used_for_user'

describe Queries::UserTopics::LastUsedForUser do
  include PavlovSupport

  describe '#call' do
    it 'returns nothing' do
      user_id = 'a1'

      query = described_class.new user_id: user_id

      expect(query.call).to eq [] # user_topics
    end
  end
end
