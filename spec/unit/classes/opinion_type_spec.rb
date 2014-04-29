require_relative '../../../app/classes/opinion_type'

describe OpinionType do
  describe '.include?' do
    it "includes the valid types" do
      expect(OpinionType).to include 'believes'
      expect(OpinionType).to include :believes
      expect(OpinionType).to include 'disbelieves'
      expect(OpinionType).to_not include 'blah'
    end
  end
end
