require 'pavlov_helper'
require_relative '../../app/classes/redis_utils'
require_relative '../../app/redis-models/topics_sorted_by_authority'

describe TopicsSortedByAuthority do
  include PavlovSupport

  let(:key)      {double}
  let(:user_id)  {'1a'}

  subject(:user_topics_by_authority) { described_class.new user_id, key }

  before do
    stub_classes 'Nest'
  end

  describe '.set' do
    it 'uses zadd to add the topic_id to the set with authority as the score' do
      authority = 100
      topic_id  = '1a'
      user_key  = double

      key.stub(:[]).with(user_id).and_return(user_key)
      user_key.should_receive(:zadd).with(authority, topic_id)

      user_topics_by_authority.set topic_id, authority
    end
  end

  describe '.ids_and_authorities_desc_limit' do
    it "returns an array of hashes sorted descending by authority" do
      user_key = double
      limit = 5

      key.stub(:[]).with(user_id).and_return(user_key)
      user_key.stub(:zrevrange).
        with(0, limit-1, withscores: true).
        and_return ["2", "20", "1", "10"]

      result = user_topics_by_authority.ids_and_authorities_desc_limit limit
      expect(result).to match_array [{id: "2", authority: 21}, {id: "1", authority: 11}]
    end

    it "returns no more than the limit" do
      user_key = double
      limit = 1

      key.stub(:[]).with(user_id).and_return(user_key)
      user_key.stub(:zrevrange).
        with(0, limit-1, withscores: true).
        and_return ["2", "20"]

      result = user_topics_by_authority.ids_and_authorities_desc_limit limit
      expect(result.length).to eq 1
    end
  end

end
