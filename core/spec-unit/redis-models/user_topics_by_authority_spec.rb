require_relative '../../app/redis-models/user_topics_by_authority'

describe UserTopicsByAuthority do

  let(:key)      {mock}
  let(:user_id)  {mock}
  let(:user_topics_by_authority) { described_class.new user_id, key }

  describe '.set' do
    it 'adds a user id to the list of handpicked users' do
      authority = mock
      topic_id  = mock
      user_key  = mock

      key.stub(:[]).with(user_id).and_return(user_key)
      user_key.should_receive(:zadd).with(authority, topic_id)

      user_topics_by_authority.set topic_id, authority
    end
  end

  describe '.ids_and_authorities_desc' do
    it "returns the users" do
      user_key = mock

      key.stub(:[]).with(user_id).and_return(user_key)
      user_key.stub(:zrevrange).
        with(0, -1, withscores: true).
        and_return ["2", "20", "1", "10"]

      result = user_topics_by_authority.ids_and_authorities_desc
      expect(result).to match_array [{id: "2", authority: 20}, {id: "1", authority: 10}]
    end
  end

end
