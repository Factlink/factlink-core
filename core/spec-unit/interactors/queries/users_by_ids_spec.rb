require 'pavlov_helper'
require_relative '../../../app/interactors/kill_object.rb'
require_relative '../../../app/interactors/queries/users_by_ids.rb'

describe Queries::UsersByIds do
  include PavlovSupport

  before do
    stub_classes 'User'
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { described_class.new(user_ids: ['g6']).call}.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe '#call' do
    it 'should work with an empty list of ids' do
      query = described_class.new(user_ids: [])

      User.stub(:any_in).with(_id: []).and_return([])

      expect(query.call).to eq []
    end

    it 'adds statistics' do
      follower_count = 123
      created_fact_count = 10
      created_facts_channel = double(sorted_cached_facts: double(size: created_fact_count))
      user = double(graph_user: double(id: '10', created_facts_channel: created_facts_channel))
      query = described_class.new(user_ids: [0])

      User.stub(:any_in).with(_id: [0]).and_return([user])

      Pavlov.stub(:query)
        .with(:'users/follower_count', graph_user_id: user.graph_user.id)
        .and_return(follower_count)

      expect(query.call[0].statistics[:created_fact_count]).to eq created_fact_count
      expect(query.call[0].statistics[:follower_count]).to eq follower_count
    end

    it 'should work with multiple ids' do
      user_ids = [0, 1]
      created_facts_channel0 = double(sorted_cached_facts: double(size: 10))
      created_facts_channel1 = double(sorted_cached_facts: double(size: 20))
      user0 = double(graph_user: double(id: '10', created_facts_channel: created_facts_channel0))
      user1 = double(graph_user: double(id: '20', created_facts_channel: created_facts_channel1))
      query = described_class.new(user_ids: user_ids)

      User.stub(:any_in).with(_id: user_ids).and_return([user0, user1])
      Pavlov.stub(:query).and_return(0)

      expect(query.call.length).to eq 2
    end
  end
end
