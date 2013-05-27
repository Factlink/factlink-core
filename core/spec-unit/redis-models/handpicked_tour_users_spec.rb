require_relative '../../app/redis-models/handpicked_tour_users'

describe HandpickedTourUsers do
  describe '.add' do
    it 'adds a user id to the list of handpicked users' do
      id = "1a"
      handpicked_tour_users_interface = mock

      handpicked_tour_users = described_class.new handpicked_tour_users_interface

      handpicked_tour_users_interface.should_receive(:sadd).with(id)

      handpicked_tour_users.add(id)
    end
  end

  describe '.remove' do
    it 'adds a user id to the list of handpicked users' do
      id = "1a"
      handpicked_tour_users_interface = mock

      handpicked_tour_users = described_class.new handpicked_tour_users_interface

      handpicked_tour_users_interface.should_receive(:srem).with(id)

      handpicked_tour_users.remove(id)
    end
  end

  describe '.handpicked_tour_users_interface' do
    it 'returns a redis interface to the handpicked users' do
      nest = mock
      interface = mock
      Nest.stub(:new).with(:user).and_return nest
      nest.stub(:[]).with(:handpicked_tour_users).and_return(interface)

      handpicked_tour_users = described_class.new

      expect(handpicked_tour_users.handpicked_tour_users_interface).to eq interface
    end
  end

  describe '.members' do
    before do
      stub_const 'User', Class.new
    end

    it "returns the users" do
      user = mock
      nest = stub smembers: ["1a"]
      User.stub(:find).with("1a").and_return user

      handpicked_tour_users = described_class.new nest

      expect(handpicked_tour_users.members).to eq [user]
    end
    it "doesn't return nil users" do
      nest = stub smembers: ["1a"]
      User.stub(:find).with("1a").and_return nil

      handpicked_tour_users = described_class.new nest

      expect(handpicked_tour_users.members).to eq []
    end
  end
end
