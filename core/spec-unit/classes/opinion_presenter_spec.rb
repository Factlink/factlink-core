require_relative '../../app/classes/opinion_presenter'

describe OpinionPresenter do
  before do
    stub_const 'NumberFormatter', Class.new
  end

  describe '#relevance' do
    it 'is 0 when the authority of the opinion is 0' do
      opinion = mock authority: 0, disbelieves: 0, believes: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end

    it 'is 1 when every user beliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, believes: 1, disbelieves: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 1
    end

    it 'is -1 when every user disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, believes: 0, disbelieves: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq(-1)
    end

    it 'is 0 when one user beliefs and one disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, believes: 1, disbelieves: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end
  end

  describe '#format' do
    it 'uses NumberFormatter.as_authority and returns that value' do
      number = mock
      number_formatter = mock as_authority: mock

      op = OpinionPresenter.new mock

      NumberFormatter.stub(:new).with(number).and_return(number_formatter)

      expect(op.format number).to eq number_formatter.as_authority
    end
  end

  describe '#authority' do
    it 'Multiplies the value of opinion.type with the authority' do
      opinion = mock believes: 2, authority: 3

      op = OpinionPresenter.new opinion

      expect(op.authority(:believes)).to eq 6
    end
  end

  describe "#as_percentages_hash" do
    it "should use the NumberFormatter for the formatting of authority" do
      authority = 13
      friendly_authority = mock
      number_formatter = mock as_authority: friendly_authority

      NumberFormatter.stub(:new).with(authority).and_return(number_formatter)

      opinion = mock believes: 0, disbelieves: 0, doubts: 0, authority: authority
      calculated_friendly_authority = OpinionPresenter.new(opinion).as_percentages_hash[:authority]
      expect(calculated_friendly_authority).to eq friendly_authority
    end
  end
end
