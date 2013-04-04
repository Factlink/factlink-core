require_relative '../../app/ohm-models/user_following_users'

describe UserFollowingUsers do

  let(:relation) { mock }
  let(:user_id) { mock }
  let(:other_id) { mock }
  let(:ids) { mock }
  let(:user_following_users) { UserFollowingUsers.new user_id, relation }

  describe '.follow' do
    it 'calls relation.add' do
      relation.should_receive(:add).with(user_id, other_id)
      user_following_users.follow other_id
    end
  end

  describe '.unfollow' do
    it 'calls relation.remove' do
      relation.should_receive(:remove).with(user_id, other_id)
      user_following_users.unfollow other_id
    end
  end

  describe '.following' do
    it 'returns relation.ids' do
      relation.should_receive(:ids).with(user_id).and_return(ids)
      result = user_following_users.following
      expect(result).to eq ids
    end
  end

  describe '.followers' do
    it 'returns relation.reverse_ids' do
      relation.should_receive(:reverse_ids).with(user_id).and_return(ids)
      result = user_following_users.followers
      expect(result).to eq ids
    end
  end

  describe '.follows?' do
    it 'calls relation.remove' do
      boolean = mock

      relation.should_receive(:has?).with(user_id, other_id).and_return(boolean)
      result = user_following_users.follows? other_id

      expect(result).to eq boolean
    end
  end
end
