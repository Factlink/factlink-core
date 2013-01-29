require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/facts'

describe Queries::Topics::Facts do
  include PavlovSupport

  before do
    stub_classes 'Nest', 'Ohm::Model::SortedSet', 'Fact'
  end

  describe '#execute' do
    it 'correctly' do
      topic_id = '1a'
      count = 10
      max_timestamp = 100
      query = described_class.new topic_id, count, max_timestamp
      fact_id = mock
      results = [{item: fact_id, score:1}]
      key = mock
      redis_opts = {withscores:true, limit:[0,count]}
      interleaved_results = mock
      fact = mock

      query.should_receive(:setup_defaults)
      query.should_receive(:redis_key).and_return(key)
      key.should_receive(:zrevrangebyscore).
        with("(#{max_timestamp}", '-inf', redis_opts).
        and_return(interleaved_results)
      Ohm::Model::SortedSet.should_receive(:hash_array_for_withscores).
        with(interleaved_results).and_return(results)
      Fact.should_receive(:[]).with(fact_id).and_return(fact)

      expect( query.execute ).to eq [{score: 1, item: fact}]
    end
  end

  describe '#setup_defaults' do
    it :max_timestamp do
      default_max_timestamp = 'inf'
      query = described_class.new '10a', 100, nil

      query.setup_defaults

      expect( query.max_timestamp ).to eq default_max_timestamp
    end
  end

  describe '#redis_key' do
    it 'calls nest correcly' do
      topic_id = '2a'
      command = described_class.new topic_id, 100, 123
      key = mock
      final_key = mock

      Nest.should_receive(:new).with(:new_topic).and_return(key)
      key.should_receive(:[]).with(topic_id).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(final_key)

      expect(command.redis_key).to eq final_key
    end
  end

  describe '#validation' do
    let(:subject_class) { described_class }

    it :topic_id do
      expect_validating('q', 100, 123).
        to fail_validation('topic_id should be an hexadecimal string.')
    end

    it :count do
      expect_validating('1e', 'q', 123).
        to fail_validation('count should be an integer.')
    end

    it :max_timestamp do
      expect_validating('1e', 100, 'q').
        to fail_validation('max_timestamp should be an integer.')
    end
  end
end
