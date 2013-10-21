require 'spec_helper'

describe CleanSortedFacts do
  describe ".perform" do
    let(:key) {Nest.new(:foo)}

    it "should not do anything if no facts were deleted" do
      f1 = create :fact
      key.zadd f1.id, 1

      CleanSortedFacts.perform key.to_s

      expect(key.zcount('-inf', 'inf')).to eq 1
    end

    it "removes facts without data_ids" do
      f1 = create :fact
      f1.data_id = nil
      f1.save
      key.zadd f1.id, 1

      CleanSortedFacts.perform key.to_s

      expect(key.zcount('-inf', 'inf')).to eq 0
    end

    it "removes a fact if the fact is nil" do
      key.zadd '13', 1

      CleanSortedFacts.perform key.to_s

      expect(key.zcount('-inf', 'inf')).to eq 0
    end

  end
end
