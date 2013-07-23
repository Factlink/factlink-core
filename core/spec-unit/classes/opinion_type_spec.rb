require_relative '../../app/classes/opinion_type'

describe OpinionType do
  describe '.real_for' do
    it "returns the proper opinion" do
      expect(OpinionType.real_for(:believes)).to eq :believes
      expect(OpinionType.real_for(:beliefs)).to eq :believes
      expect(OpinionType.real_for(:disbelieves)).to eq :disbelieves
      expect(OpinionType.real_for(:disbeliefs)).to eq :disbelieves
      expect(OpinionType.real_for(:doubts)).to eq :doubts
    end
    it "raises when improper input is given" do
      expect {OpinionType.real_for(:henk)}.to raise_error RuntimeError, "invalid opinion"
    end
  end
  describe '.for_relation_type' do
    it "returns the proper opinion" do
      expect(OpinionType.for_relation_type(:supporting)).to eq :believes
      expect(OpinionType.for_relation_type(:weakening)).to eq :disbelieves
    end
  end
  describe '.types' do
    it "includes the valid types" do
      expect(OpinionType.types).to include :believes
      expect(OpinionType.types).to include :doubts
      expect(OpinionType.types).to include :disbelieves
    end
  end
end
