require_relative '../../app/classes/opinion_presenter'

describe OpinionPresenter do
  describe '.belief_authority' do
    it 'is 0 when the authority of the opinion is 0' do
      opinion = mock a: 0, b: 0

      op = OpinionPresenter.new opinion
      expect(op.belief_authority).to eq 0
    end

    it 'is 1 when every user believes and the sum of every users authority is 1' do
      opinion = stub :opinion, a: 1, b: 1

      op = OpinionPresenter.new opinion
      expect(op.belief_authority).to eq 1
    end

    it 'is 0 when no user believes' do
      opinion = stub :opinion, a: 1, b: 0, d: 1

      op = OpinionPresenter.new opinion
      expect(op.belief_authority).to eq 0
    end
  end

  describe '.disbelief_authority' do
    it 'is 0 when the authority of the opinion is 0' do
      opinion = mock a: 0, d: 0

      op = OpinionPresenter.new opinion
      expect(op.disbelief_authority).to eq 0
    end

    it 'is 1 when every user disbelieves and the sum of every users authority is 1' do
      opinion = stub :opinion, a: 1, d: 1

      op = OpinionPresenter.new opinion
      expect(op.disbelief_authority).to eq 1
    end

    it 'is 0 when no user disbelieves' do
      opinion = stub :opinion, a: 1, b: 1, d: 0

      op = OpinionPresenter.new opinion
      expect(op.disbelief_authority).to eq 0
    end
  end

  describe '.relevance' do
    it 'is 0 when the authority of the opinion is 0' do
      opinion = mock a: 0, d: 0, b: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end

    it 'is 1 when every user believes and the sum of every users authority is 1' do
      opinion = stub :opinion, a: 1, b: 1, d: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 1
    end

    it 'is -1 when every user disbelieves and the sum of every users authority is 1' do
      opinion = stub :opinion, a: 1, b: 0, d: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq(-1)
    end

    it 'is 0 when one user believes and one disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, a: 1, b: 1, d: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end
  end
end
