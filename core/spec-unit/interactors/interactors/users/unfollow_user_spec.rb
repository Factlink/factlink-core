require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/unfollow_user'

describe Interactors::Users::UnfollowUser do
  include PavlovSupport

  before do
    stub_classes 'Backend::UserFollowers'
  end

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect do
        described_class.new(username: 'bar').call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls a command to unfollow' do
      username = 'henk'
      user = double(graph_user_id: double, username: 'jan')
      pavlov_options = { current_user: user }
      user_to_unfollow = double(graph_user_id: double)
      interactor = described_class.new username: username,
                                       pavlov_options: pavlov_options

      Pavlov.should_receive(:query)
            .with(:'user_by_username',
                      username: username, pavlov_options: pavlov_options)
            .and_return(user_to_unfollow)

      expect(Backend::UserFollowers).to receive(:unfollow)
            .with(follower_id: user.graph_user_id,
                  followee_id: user_to_unfollow.graph_user_id)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'validates username' do
      expect_validating(username: 12)
        .to fail_validation 'username should be a nonempty string.'
    end
  end
end
