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

  describe '.formatted_belief_authority' do
    it 'calls format with belief_authority and returns that result' do
      belief_authority = mock
      format = mock

      op = OpinionPresenter.new mock

      op.should_receive(:belief_authority).and_return(belief_authority)
      op.should_receive(:format).with(belief_authority).and_return(format)

      expect(op.formatted_belief_authority).to eq format
    end
  end

  describe '.formatted_disbelief_authority' do
    it 'calls format with disbelief_authority and returns that result' do
      disbelief_authority = mock
      format = mock

      op = OpinionPresenter.new mock

      op.should_receive(:disbelief_authority).and_return(disbelief_authority)
      op.should_receive(:format).with(disbelief_authority).and_return(format)

      expect(op.formatted_disbelief_authority).to eq format
    end
  end

  describe '.formatted_relevance' do
    it 'calls format with relevance and returns that result' do
      relevance = mock
      format = mock

      op = OpinionPresenter.new mock

      op.should_receive(:relevance).and_return(relevance)
      op.should_receive(:format).with(relevance).and_return(format)

      expect(op.formatted_relevance).to eq format
    end
  end
end
