require_relative '../../app/classes/opinion_type'

describe OpinionType do
  describe '.types' do
    it "includes the valid types" do
      expect(OpinionType.types).to include 'believes'
      expect(OpinionType.types).to include 'doubts'
      expect(OpinionType.types).to include 'disbelieves'
    end
  end
end
