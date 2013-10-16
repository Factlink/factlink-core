require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/channels/facts'
require 'active_support/core_ext/object/blank'

describe Queries::Channels::Facts do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      sorted_facts = double
      sorted_facts_page = double
      channel = double id: '1', sorted_cached_facts: sorted_facts

      count = 77
      from = 990

      query = described_class.new id: channel.id, from: from, count: count

      Pavlov.stub(:query)
            .with(:'channels/get', id: channel.id)
            .and_return(channel)
      sorted_facts.stub(:below)
                  .with(from, {count: count, reversed: true, withscores: true})
                  .and_return(sorted_facts_page)

      expect(query.call).to eq sorted_facts_page
    end
  end
end
