require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/user_opinion_for_comment.rb'


describe Queries::Opinions::UserOpinionForComment do
  include PavlovSupport

  before do
    stub_classes 'Believable::Commentje', 'UserOpinionCalculation',
                 'Authority', 'DeadOpinion'
  end

  it 'initializes' do
    described_class.new '1', mock
  end

  describe 'validation' do
    it 'with a invalid comment_id doesn''t validate' do
      expect_validating('g', mock).
        to fail_validation 'comment_id should be an hexadecimal string.'
    end
  end

  describe '.call' do
    it "returns the dead opinion the calculator calculates" do
      opinion = mock
      dead_opinion = mock
      calculator = mock(:calculator, opinion: opinion)
      query = described_class.new 'a1', mock
      query.stub calculator: calculator

      DeadOpinion.stub(:from_opinion).with(opinion).and_return(dead_opinion)

      expect(query.call).to eq dead_opinion
    end
  end

  describe 'calculator' do
    it "calls the UserOpinionCalculation with the authority_for" do
      believable = mock
      authority_block = Proc.new {|u| 1 }
      calculator = mock

      query = described_class.new '1', mock

      query.stub believable: believable,
                 authority_for: authority_block

      UserOpinionCalculation.should_receive(:new)
                            .with(believable) # and authorityblock, but that is apparantly untestable :/
                            .and_return(calculator)

      expect(query.calculator).to eq calculator
    end
  end

  describe 'authority_for' do
    it "returns a block which calculates authority for the user" do
      fact = mock
      graph_user = mock
      authority = 1515

      query = described_class.new '1', fact
      auth = query.authority_for

      Authority.should_receive(:on)
               .with(fact, for: graph_user)
               .and_return(authority)

      expect(auth.call(graph_user)).to eq authority + 1
    end
  end

  describe '.believable' do
    it "returns the Believable::Commentje for this comment" do
      id = 'a1'
      believable = mock
      query = described_class.new id, mock

      Believable::Commentje.should_receive(:new)
                       .with(id)
                       .and_return(believable)

      expect(query.believable).to eq believable
    end
  end

end
