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

      Pavlov.stub(:old_query)
            .with(:users_by_ids, [],)
            .and_return([])

      expect(query.call).to eq([])
    end

    it "should work with multiple ids" do
      graph_users = [
        mock(id: 1, user_id: 4),
        mock(id: 2, user_id: 5),
        mock(id: 3, user_id: 6)
      ]
      gu_ids = graph_users.map(&:id)
      user_ids = graph_users.map(&:user_id)

      users = double

      graph_users.each do |graph_user|
        GraphUser.should_receive(:[])
                 .with(graph_user.id)
                 .and_return(graph_user)
      end

      query = described_class.new(graph_user_ids: gu_ids)

      Pavlov.stub(:old_query)
            .with(:users_by_ids, user_ids)
            .and_return(users)

      expect(query.call).to eq(users)
    end
  end
end
