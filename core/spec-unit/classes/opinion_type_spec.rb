require_relative '../../app/classes/opinion_type'

describe OpinionType do
  describe '.real_for' do
    it "should return the proper opinion" do
      expect(OpinionType.real_for(:believes)).to eq :believes
      expect(OpinionType.real_for(:beliefs)).to eq :believes
      expect(OpinionType.real_for(:disbelieves)).to eq :disbelieves
      expect(OpinionType.real_for(:disbeliefs)).to eq :disbelieves
      expect(OpinionType.real_for(:doubts)).to eq :doubts
    end
    it "should raise when improper input is given" do
      expect {OpinionType.real_for(:henk)}.to raise_error RuntimeError, "invalid opinion"
    end
  end
end
