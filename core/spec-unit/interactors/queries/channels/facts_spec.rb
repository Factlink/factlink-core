require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/channels/facts'
require 'active_support/core_ext/object/blank'

describe Queries::Channels::Facts do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      sorted_facts_page = double
      channel = double id: '1', sorted_cached_facts: double(key: "foo")

      count = 77
      from = 990

      query = described_class.new id: channel.id, from: from, count: count

      allow(Pavlov).to receive(:query)
        .with(:'channels/get', id: channel.id)
        .and_return(channel)
      allow(Pavlov).to receive(:query)
        .with(:'facts/get_paginated',
              key: channel.sorted_cached_facts.key.to_s,
              count: count, from: from)
        .and_return(sorted_facts_page)

      expect(query.call).to eq sorted_facts_page
    end
  end
end
