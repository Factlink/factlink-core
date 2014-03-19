require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/following'

describe Interactors::Users::Following do
  include PavlovSupport

  before do
    stub_classes 'Backend::UserFollowers', 'Backend::Users'
  end

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect do
        interactor = described_class.new(username: 'gerard')
        interactor.call
      end.to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe 'validations' do
    it 'invalid username doesn\'t validate' do
      expect_validating(username: 1)
        .to fail_validation('username should be a nonempty string.')
    end
  end

  describe '#call' do
    it 'it calls the query to get a list of following users' do
      graph_user_ids = [1, 4, 5, 6, 2, 3]
      users = graph_user_ids.map { |id| double graph_user_id: id}

      followed_user = double(graph_user_id: double, username: 'henk')

      pavlov_options = { current_user: double}
      interactor = described_class.new username: followed_user.username, pavlov_options: pavlov_options

      allow(Backend::Users).to receive(:user_by_username)
        .with(username: followed_user.username)
        .and_return(followed_user)
      allow(Backend::UserFollowers).to receive(:followee_ids)
        .with(follower_id: followed_user.graph_user_id.to_s)
        .and_return(graph_user_ids)
      allow(Backend::Users).to receive(:by_ids)
        .with(user_ids: anything,
              by: :graph_user_id) do |options|
          options[:user_ids].map do |id|
            users.select { |user| user.graph_user_id == id }.first
          end
        end

      returned_users = interactor.call

      expect(returned_users).to eq users
    end
  end
end
