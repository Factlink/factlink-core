require_relative '../../app/workers/add_all_containing_factlinks_to_topic'

describe AddAllContainingFactlinksToTopic do
  before do
    @topic_id = mock
    @topic = mock

    stub_const("Topic", Class.new)

    Topic.stub(:find).with(@topic_id).and_return(@topic)
  end

  describe '#initialize' do
    it 'locates the Topic matching topic_id' do
      Topic.should_receive(:find).with(@topic_id).and_return(@topic)

      worker_instance = described_class.new(@topic_id)

      expect(worker_instance.instance_variable_get(:@topic)).to eq @topic
    end
  end

  describe '#perform' do
    it 'should perform a zunionstore' do
      redis_key = mock
      sorted_cached_facts_keys = mock
      result = mock

      worker = described_class.new(@topic_id)

      worker.should_receive(:redis_key).and_return(redis_key)
      worker.should_receive(:sorted_cached_facts_keys).and_return(sorted_cached_facts_keys)
      redis_key.should_receive(:zunionstore).with(sorted_cached_facts_keys, aggregate: 'min').and_return(result)

      expect(worker.perform).to eq result
    end
  end

  describe '#redis_key' do
    it 'should return the topics :facts key on the redis object' do
      redis = mock
      redis_for_topic = mock
      facts_key = mock
      slug_title = mock

      worker = described_class.new(@topic_id)

      worker.should_receive(:slug_title).and_return(slug_title)
      Topic.should_receive(:redis).and_return(redis)
      redis.should_receive(:[]).with(slug_title).and_return(redis_for_topic)
      redis_for_topic.should_receive(:[]).with(:facts).and_return(facts_key)

      expect(worker.redis_key).to eq facts_key
    end
  end

  describe '#slug_title' do
    it 'should return the topic''s slug_title' do
      slug_title = mock

      worker = described_class.new(@topic_id)

      @topic.should_receive(:slug_title).and_return(slug_title)

      expect(worker.slug_title).to eq slug_title
    end
  end

  describe '#channels' do
    it 'should return the topics channels' do
      channels = mock

      worker = described_class.new(@topic_id)

      @topic.should_receive(:channels).and_return(channels)

      expect(worker.channels).to eq channels
    end
  end

  describe '#sorted_cached_facts_keys' do
    it 'should return the key of sorted_cached_facts set of each channel' do
      channel1 = mock
      key1 = mock
      channel2 = mock
      key2 = mock
      channels = [channel1, channel2]
      keys = [key1, key2]

      worker = described_class.new(@topic_id)

      worker.should_receive(:channels).and_return(channels)

      channel1.should_receive(:sorted_cached_facts).and_return(mock(key: key1))
      channel2.should_receive(:sorted_cached_facts).and_return(mock(key: key2))

      expect(worker.sorted_cached_facts_keys).to eq keys
    end
  end

  describe '.perform' do
    it 'initiates the described class and calls perform on the instance' do
      instance = mock
      result = mock

      described_class.should_receive(:new).with(@topic_id).and_return(instance)
      instance.should_receive(:perform).and_return(result)

      expect(described_class.perform(@topic_id)).to eq result
    end
  end
end