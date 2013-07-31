require_relative '../../app/redis-models/user_following_users'

describe UserFollowingUsers do

  let(:relation) { mock }
  let(:graph_user_id) { mock }
  let(:other_id) { mock }
  let(:ids) { mock }
  let(:user_following_users) { UserFollowingUsers.new graph_user_id, relation }

  describe '.follow' do
    it 'calls relation.add_now' do
      relation.should_receive(:add_now).with(graph_user_id, other_id)
      user_following_users.follow other_id
    end
  end

  describe '.unfollow' do
    it 'calls relation.remove' do
      relation.should_receive(:remove).with(graph_user_id, other_id)
      user_following_users.unfollow other_id
    end
  end

  describe '.following_ids' do
    it 'returns relation.ids' do
      relation.should_receive(:ids).with(graph_user_id).and_return(ids)
      result = user_following_users.following_ids
      expect(result).to eq ids
    end
  end

  describe '.followers_ids' do
    it 'returns relation.reverse_ids' do
      relation.should_receive(:reverse_ids).with(graph_user_id).and_return(ids)
      result = user_following_users.followers_ids
      expect(result).to eq ids
    end
  end

  describe '.follows?' do
    it 'calls relation.remove' do
      boolean = double

      relation.should_receive(:has?).with(graph_user_id, other_id).and_return(boolean)
      result = user_following_users.follows? other_id

      expect(result).to eq boolean
    end
  end

end
