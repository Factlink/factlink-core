require 'spec_helper'

describe Queries::Facts::GetPaginated do
  include PavlovSupport

  it "returns paginated facts" do
    user = create :full_user

    as(user) do |pavlov|
      fact1 = pavlov.command 'facts/create',
                displaystring: 'foo', title: 'foo', creator: user
      sleep 0.1
      fact2 = pavlov.command 'facts/create',
                displaystring: 'foo', title: 'foo', creator: user
      sleep 0.1
      fact3 = pavlov.command 'facts/create',
                displaystring: 'foo', title: 'foo', creator: user

      result = pavlov.query 'facts/get_paginated',
                 key: user.graph_user.sorted_created_facts.key.to_s,
                 from: 'inf', count: 2

      fact_ids = result.map do |fact_with_score|
        fact_with_score[:item].id
      end

      expect(fact_ids).to eq [fact3.id, fact2.id]
    end
  end
end
