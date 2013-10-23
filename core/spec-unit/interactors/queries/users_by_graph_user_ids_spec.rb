require 'pavlov_helper'
require_relative '../../../app/interactors/queries/users_by_graph_user_ids.rb'

describe Queries::UsersByGraphUserIds do
  include PavlovSupport

  before do
    stub_classes "GraphUser"
  end

  it 'throws when initialized with a argument that is not an integer' do
    expect { described_class.new(graph_user_ids: ['g6']).call }.
      to raise_error(RuntimeError, 'id should be a positive integer.')
  end

  describe '#call' do
    it "should work with an empty list of ids" do
      query = described_class.new(graph_user_ids: [])

      Pavlov.stub(:query)
            .with(:'users_by_ids', user_ids: [], by: :graph_user_id)
            .and_return([])

      expect(query.call).to eq([])
    end

    it "should work with multiple ids" do
      gu_ids = ['10', '35', '15']

      users = double
      query = described_class.new(graph_user_ids: gu_ids)

      Pavlov.stub(:query)
            .with(:'users_by_ids', user_ids: gu_ids, by: :graph_user_id)
            .and_return(users)

      expect(query.call).to eq(users)
    end
  end
end
