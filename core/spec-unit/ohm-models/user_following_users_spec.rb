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

  describe '.following_ids' do
    it 'returns relation.ids' do
      relation.should_receive(:ids).with(user_id).and_return(ids)
      result = user_following_users.following_ids
      expect(result).to eq ids
    end
  end

  describe '.followers_ids' do
    it 'returns relation.reverse_ids' do
      relation.should_receive(:reverse_ids).with(user_id).and_return(ids)
      result = user_following_users.followers_ids
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

  describe '.following' do
    it 'calls ids_to_objects with following_ids' do
      users = mock

      user_following_users.should_receive(:following_ids).and_return(ids)
      user_following_users.should_receive(:ids_to_objects).and_return(users)
      result = user_following_users.following

      expect(result).to eq users
    end
  end

  describe '.followers' do
    it 'calls ids_to_objects with following_ids' do
      users = mock
      
      user_following_users.should_receive(:followers_ids).and_return(ids)
      user_following_users.should_receive(:ids_to_objects).and_return(users)
      result = user_following_users.followers

      expect(result).to eq users
    end
  end

  describe '.ids_to_objects' do
    it "should filter hidden and non-existing users" do
      stub_const 'User', Class.new

      user1 = mock(hidden: true)
      user2 = nil
      user3 = mock(hidden: false)

      User.should_receive(:find).with(1).and_return(user1)
      User.should_receive(:find).with(2).and_return(user2)
      User.should_receive(:find).with(3).and_return(user3)

      result = user_following_users.ids_to_objects [1, 2, 3]

      expect(result).to eq [user3]
    end
  end
end
