require "spec_helper"

describe Activity::For do
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }

  describe ".fact" do
    it "should return creation activity" do
      f1 = create :fact, created_by: gu1
      Activity::For.fact(f1).map(&:to_hash_without_time).should == [
        {user: gu1, action: :created, subject: f1}
      ]
    end


    it "should return only creation activity on the fact queried" do
      f1 = create :fact, created_by: gu1
      f2 = create :fact, created_by: gu1
      f3 = create :fact, created_by: gu1
      Activity::For.fact(f1).map(&:to_hash_without_time).should == [
        {user: gu1, action: :created, subject: f1}
      ]
    end

  end
end
