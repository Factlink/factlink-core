require 'pavlov_helper'
require_relative '../../../app/interactors/queries/users_by_graph_user_ids.rb'

describe Queries::UsersByGraphUserIds do
  include PavlovSupport

  before do
    stub_classes "GraphUser", "User"
  end

  it 'throws when initialized with a argument that is not an integer' do
    expect { Queries::UsersByGraphUserIds.new ['g6'] }.
      to raise_error(RuntimeError, 'id should be a positive integer.')
  end

  describe ".call" do
    it "should work with an empty list of ids" do
      should_receive_new_with_and_receive_call(
          Queries::UsersByIds, [], {}).and_return([])

      Queries::UsersByGraphUserIds.any_instance.stub(authorized?: true)

      result = Queries::UsersByGraphUserIds.new([]).call

      expect(result).to eq([])
    end

    it "should work with multiple ids" do
      graph_users = [mock(user_id: 4), mock(user_id: 5), mock(user_id: 6)]
      gu_ids = [1, 2, 3]

      users = mock()

      gu_ids.each_with_index do |graph_user_id, index|
        GraphUser.should_receive(:[]).with(graph_user_id).and_return(graph_users[index])
      end

      should_receive_new_with_and_receive_call(
          Queries::UsersByIds, graph_users.map {|gu| gu.user_id }, {}).
          and_return(users)


      Queries::UsersByGraphUserIds.any_instance.stub(authorized?: true)

      result = Queries::UsersByGraphUserIds.new(gu_ids).call
      expect(result).to eq(users)
    end
  end
end
