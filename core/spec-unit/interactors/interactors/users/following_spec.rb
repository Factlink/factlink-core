require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/following'

describe Interactors::Users::Following do
  include PavlovSupport

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect do
        interactor = described_class.new(user_name: 'gerard')
        interactor.call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe 'validations' do
    it 'invalid user_name doesn\t validate' do
      expect_validating(user_name: 1)
        .to fail_validation('user_name should be a nonempty string.')
    end
  end

  describe '#call' do
    it 'it calls the query to get a list of following users' do
      graph_user_ids = [1, 4, 5, 6, 2, 3]
      users = graph_user_ids.map { |id| double graph_user_id: id}

      followed_user = double(graph_user_id: double, username: 'henk')

      pavlov_options = { current_user: double}
      interactor = described_class.new user_name: followed_user.username, pavlov_options: pavlov_options

      allow(Pavlov).to receive(:query)
        .with(:'user_by_username', username: followed_user.username, pavlov_options: pavlov_options)
        .and_return(followed_user)
      allow(Pavlov).to receive(:query)
        .with(:'users/following_graph_user_ids',
              graph_user_id: followed_user.graph_user_id.to_s, pavlov_options: pavlov_options)
        .and_return(graph_user_ids)
      allow(Pavlov).to receive(:query)
        .with(:'dead_users_by_ids',
              user_ids: anything,
              by: :graph_user_id,
              pavlov_options: pavlov_options) do |cmd, options|
          options[:user_ids].map do |id|
            users.select { |user| user.graph_user_id == id }.first
          end
        end

      returned_users = interactor.call

      expect(returned_users).to eq users
    end
  end
end
