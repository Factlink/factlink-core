require 'spec_helper'

shared_examples_for 'a believable object' do
  describe "people believes redis keys" do
    it "should be cleaned up after delete" do
      user = create(:graph_user)
      key = subject.key['people_believes'].to_s
      subject.add_opinion(:believes, user)
      redis = Redis.current
      expect(redis.smembers(key)).to eq [user.id]
      subject.delete
      expect(redis.smembers(key)).to eq []
    end
  end
end
