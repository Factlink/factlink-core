require 'pavlov_helper'
require_relative '../../app/redis-models/handpicked_tour_users'

describe HandpickedTourUsers do
  include PavlovSupport

  before do
    stub_classes 'Nest'
  end

  describe '.add' do
    it 'adds a user id to the list of handpicked users' do
      id = 1
      handpicked_tour_users_interface = double

      handpicked_tour_users = described_class.new handpicked_tour_users_interface

      handpicked_tour_users_interface.should_receive(:sadd).with(id.to_s)

      handpicked_tour_users.add(id)
    end
  end

  describe '.remove' do
    it 'adds a user id to the list of handpicked users' do
      id = 1
      handpicked_tour_users_interface = double

      handpicked_tour_users = described_class.new handpicked_tour_users_interface

      handpicked_tour_users_interface.should_receive(:srem).with(id.to_s)

      handpicked_tour_users.remove(id)
    end
  end

  describe '.handpicked_tour_users_interface' do
    it 'returns a redis interface to the handpicked users' do
      nest = double
      interface = double
      Nest.stub(:new).with(:user).and_return nest
      nest.stub(:[]).with(:handpicked_tour_users).and_return(interface)

      handpicked_tour_users = described_class.new

      expect(handpicked_tour_users.handpicked_tour_users_interface).to eq interface
    end
  end

  describe '.ids' do
    before do
      stub_const 'User', Class.new
    end

    it "returns the users" do
      user = double
      nest = stub smembers: ["1"]

      handpicked_tour_users = described_class.new nest

      expect(handpicked_tour_users.ids).to eq ["1"]
    end
  end
end
