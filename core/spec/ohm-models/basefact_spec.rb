require 'spec_helper'

describe Basefact do
  subject {create(:basefact)}

  let(:user)  {create(:graph_user)}

  describe "#created_by" do
    context "after setting it" do
      before do
        subject.created_by = user
        subject.save
      end

      it "should have the created_by set" do
        subject.created_by.should == user
      end

      it "should have the created_by persisted" do
        Basefact[subject.id].created_by.should == user
      end

      it "should be findable via find" do
        Basefact.find(created_by_id: user.id).all.should include(subject)
      end
    end
  end

  describe "people believes redis keys" do
    it "should be cleaned up after delete" do
      key = subject.key['people_believes'].to_s
      subject.add_opinion(:believes, user)
      redis = Redis.current
      expect(redis.smembers(key)).to eq [user.id]
      subject.delete
      expect(redis.smembers(key)).to eq []
    end
  end

end
