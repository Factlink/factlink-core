require_relative '../../app/ohm-models/recently_viewed_facts'

describe RecentlyViewedFacts do
  before do
    stub_const 'Fact', Class.new
  end

  describe '.push_fact_id' do
    it 'only adds the fact id' do
      nest = mock
      current_time = mock
      fact_id = mock

      RecentlyViewedFacts.stub current_time: current_time

      nest.should_receive(:zadd).with(current_time, fact_id)

      RecentlyViewedFacts.new(nest).push_fact_id fact_id
    end
  end

  describe '.top_facts' do
    it 'retrieves the last "count" facts' do
      fact = mock id: 14
      nest = mock
      count = 10

      nest.should_receive(:zrevrange).with(0, count-1).and_return([fact.id])

      Fact.should_receive(:[]).any_number_of_times.with(fact.id).and_return fact

      result = RecentlyViewedFacts.new(nest).top_facts count

      expect(result).to eq [fact]
    end

    it 'doesnt return nil facts' do
      fact_id = 14
      nest = stub zrevrange: [fact_id]

      Fact.should_receive(:[]).any_number_of_times.with(fact_id).and_return nil

      result = RecentlyViewedFacts.new(nest).top_facts 10

      expect(result).to eq []
    end
  end

  describe '.truncate' do
    it 'removes all elements except "keep_count' do
      nest = mock
      keep_count = 20

      nest.should_receive(:zremrangebyrank).with(0, -keep_count-1)

      RecentlyViewedFacts.new(nest).truncate keep_count
    end
  end

  describe '#by_user_id' do
    it 'uses a key with :user:id' do
      nest = mock
      nest_user = mock
      nest_user_id = mock
      user_id = 20

      nest.should_receive(:[]).with(:user).and_return(nest_user)
      nest_user.should_receive(:[]).with(user_id).and_return(nest_user_id)

      expect(RecentlyViewedFacts.by_user_id(user_id, nest).nest_key).to eq nest_user_id
    end
  end
end
