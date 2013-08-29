require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/channels/facts'
require 'active_support/core_ext/object/blank'

describe Queries::Channels::Facts do
  include PavlovSupport

  before do
    stub_classes 'Channel'
  end

  describe '.validate' do
    it 'requires id to be an integer' do
      expect_validating(id: 'a', from: 7, count: 10)
        .to fail_validation('id should be an integer string.')
    end

    it 'requires from to be an integer' do
      expect_validating(id: '1', from: 'a', count: 0)
        .to fail_validation('from should be an integer.')
    end

    it 'requires count to be an integer' do
      expect_validating(id: '1', from: 1, count: 'a')
        .to fail_validation('count should be an integer.')
    end
  end

  describe '#call' do
    it 'correctly' do
      channel_id = '1'
      count = 77
      from = 990
      query = described_class.new id: channel_id, from: from, count: count
      sorted_facts = double
      channel = double
      sorted_facts_page = double

      Pavlov.stub(:query)
            .with(:'channels/get',
                      id: channel_id)
            .and_return(channel)
      channel.stub(:sorted_cached_facts).and_return(sorted_facts)
      sorted_facts.stub(:below).with(from, {count: count, reversed: true, withscores: true}).and_return(sorted_facts_page)

      expect(query.call).to eq sorted_facts_page
    end
  end
end
