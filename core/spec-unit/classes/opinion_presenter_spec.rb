require_relative '../../app/classes/opinion_presenter'

describe OpinionPresenter do
  before do
    stub_const 'NumberFormatter', Class.new
  end

  describe '#relevance' do
    it 'is 0 when the authority of the opinion is 0' do
      opinion = mock authority: 0, disbeliefs: 0, beliefs: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end

    it 'is 1 when every user beliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, beliefs: 1, disbeliefs: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 1
    end

    it 'is -1 when every user disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, beliefs: 0, disbeliefs: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq(-1)
    end

    it 'is 0 when one user beliefs and one disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, beliefs: 1, disbeliefs: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end
  end

  describe '#formatted_relevance' do
    it 'calls format with relevance and returns that result' do
      relevance = mock
      format = mock

      op = OpinionPresenter.new mock

      op.should_receive(:relevance).and_return(relevance)
      op.should_receive(:format).with(relevance).and_return(format)

      expect(op.formatted_relevance).to eq format
    end
  end

  describe '#format' do
    it 'uses NumberFormatter.as_authority and returns that value' do
      number_formatter = mock
      number = mock
      as_authority = mock

      op = OpinionPresenter.new mock

      NumberFormatter.should_receive(:new).and_return(number_formatter)
      number_formatter.should_receive(:as_authority).and_return(as_authority)

      expect(op.format number).to eq as_authority
    end
  end

  describe '#authority' do
    it 'Multiplies the value of opinion.type with the authority' do
      opinion = mock
      type_sym = :symbol
      type_val = mock
      result = mock
      authority = mock

      op = OpinionPresenter.new opinion

      opinion.should_receive(type_sym).and_return(type_val)
      opinion.should_receive(:authority).and_return(authority)
      type_val.should_receive(:*).with(authority).and_return(result)

      expect(op.authority(type_sym)).to eq result
    end
  end

  describe "#as_percentages_hash" do
    it "should use the NumberFormatter for the formatting of authority" do
      authority = 13
      friendly_authority = mock
      number_formatter = mock as_authority: friendly_authority

      NumberFormatter.stub(:new).with(authority).and_return(number_formatter)

      opinion = mock b: 0, d: 0, u: 0, a: authority
      calculated_friendly_authority = OpinionPresenter.new(opinion).as_percentages_hash[:authority]
      expect(calculated_friendly_authority).to eq friendly_authority
    end
  end
end
