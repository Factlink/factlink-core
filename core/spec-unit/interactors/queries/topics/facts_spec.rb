require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/facts'

describe Queries::Topics::Facts do
  include PavlovSupport

  before do
    stub_classes 'Topic', 'Ohm::Model::SortedSet', 'Fact'
  end

  describe '#call' do
    it 'correctly' do
      slug_title = 'slug-title'
      count = 10
      max_timestamp = 100
      query = described_class.new slug_title: slug_title, count: count,
        max_timestamp: max_timestamp
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
      Fact.should_receive(:invalid).with(fact).and_return(false)

      expect( query.call ).to eq [{score: 1, item: fact}]
    end
  end

  describe '#setup_defaults' do
    it :max_timestamp do
      default_max_timestamp = 'inf'
      query = described_class.new slug_title: '10a', count: 100,
        max_timestamp: nil

      query.setup_defaults

      expect( query.max_timestamp ).to eq default_max_timestamp
    end
  end

  describe '#redis_key' do
    it 'calls nest correcly' do
      slug_title = 'slug-title'
      command = described_class.new slug_title: slug_title, count: 100,
        max_timestamp: 123
      nest = mock
      key = mock
      final_key = mock

      Topic.should_receive(:redis).and_return(nest)
      nest.should_receive(:[]).with(slug_title).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(final_key)

      expect(command.redis_key).to eq final_key
    end
  end

  describe '#validation' do
    it :slug_title do
      expect_validating(slug_title: 1, count: 100, max_timestamp: 123).
        to fail_validation('slug_title should be a string.')
    end

    it :count do
      expect_validating(slug_title: '1e', count: 'q', max_timestamp: 123).
        to fail_validation('count should be an integer.')
    end

    it :max_timestamp do
      expect_validating(slug_title: '1e', count: 100, max_timestamp: 'q').
        to fail_validation('max_timestamp should be an integer.')
    end
  end
end
