require 'spec_helper'

describe Queries::Facts::GetPaginated do
  include PavlovSupport

  it "returns paginated facts" do
    user = create :full_user

    as(user) do |pavlov|
      fact1 = pavlov.interactor :'facts/create',
                displaystring: 'foo', title: 'foo', url: 'http://example.org'
      sleep 0.001 # ensure different timestamp
      fact2 = pavlov.interactor :'facts/create',
                displaystring: 'foo', title: 'foo', url: 'http://example.org'
      sleep 0.001 # ensure different timestamp
      fact3 = pavlov.interactor :'facts/create',
                displaystring: 'foo', title: 'foo', url: 'http://example.org'

      result = pavlov.query :'facts/get_paginated',
                 key: user.graph_user.sorted_created_facts.key.to_s,
                 from: 'inf', count: 2

      result_fact_ids = result.map do |fact_with_score|
        fact_with_score[:item].id
      end

      expect(result_fact_ids).to eq [fact3.id, fact2.id]
    end
  end
end
