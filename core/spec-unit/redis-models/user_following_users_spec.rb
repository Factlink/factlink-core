require_relative '../../app/redis-models/user_following_users'

describe UserFollowingUsers do

  let(:relation) { double }
  let(:graph_user_id) { double }
  let(:other_id) { double }
  let(:ids) { double }
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
      relation.stub(:ids).with(graph_user_id).and_return(ids)

      expect(user_following_users.following_ids).to eq ids
    end
  end

  describe '.followers_ids' do
    it 'returns relation.reverse_ids' do
      relation.stub(:reverse_ids).with(graph_user_id).and_return(ids)

      expect(user_following_users.followers_ids).to eq ids
    end
  end

  describe '.follows?' do
    it 'calls relation.remove' do
      boolean = double

      relation.stub(:has?).with(graph_user_id, other_id).and_return(boolean)

      result = user_following_users.follows? other_id
      expect(result).to eq boolean
    end
  end

  describe '.following_count' do
    it 'returns relation.count' do
      count = double

      relation.stub(:count).with(graph_user_id).and_return(count)

      expect(user_following_users.following_count).to eq count
    end
  end

  describe '.followers_count' do
    it 'returns relation.reverse_count' do
      count = double

      relation.stub(:reverse_count).with(graph_user_id).and_return(count)

      expect(user_following_users.followers_count).to eq count
    end
  end

end
