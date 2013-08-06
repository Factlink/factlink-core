require_relative '../../app/ohm-models/recently_viewed_facts'

describe RecentlyViewedFacts do
  before do
    stub_const 'Fact', Class.new
  end

  describe '.add_fact_id' do
    it 'only adds the fact id' do
      nest = double
      current_time = double
      fact_id = double

      RecentlyViewedFacts.stub current_time: current_time

      nest.should_receive(:zadd).with(current_time, fact_id)

      RecentlyViewedFacts.new(nest).add_fact_id fact_id
    end
  end

  describe '.top' do
    it 'retrieves the last "count" facts' do
      fact = double id: 14
      nest = double
      count = 10

      nest.should_receive(:zrevrange).with(0, count-1).and_return([fact.id])

      Fact.stub(:[]).with(fact.id).and_return fact

      result = RecentlyViewedFacts.new(nest).top count

      expect(result).to eq [fact]
    end

    it 'doesnt return nil facts' do
      fact_id = 14
      nest = double zrevrange: [fact_id]

      Fact.stub(:[]).with(fact_id).and_return nil

      result = RecentlyViewedFacts.new(nest).top 10

      expect(result).to eq []
    end
  end

  describe '.truncate' do
    it 'removes all elements except "keep_count' do
      nest = double
      keep_count = 20

      nest.should_receive(:zremrangebyrank).with(0, -keep_count-1)

      RecentlyViewedFacts.new(nest).truncate keep_count
    end
  end

  describe '#by_user_id' do
    it 'uses a key with :user:id' do
      nest = double
      nest_user = double
      nest_user_id = double
      user_id = 20

      nest.should_receive(:[]).with(:user).and_return(nest_user)
      nest_user.should_receive(:[]).with(user_id).and_return(nest_user_id)

      expect(RecentlyViewedFacts.by_user_id(user_id, nest).nest_key).to eq nest_user_id
    end
  end
end
