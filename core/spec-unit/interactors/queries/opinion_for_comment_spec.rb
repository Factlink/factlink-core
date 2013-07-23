require 'pavlov_helper'
require_relative '../../../app/interactors/queries/opinion_for_comment.rb'

describe Queries::OpinionForComment do
  include PavlovSupport

  before do
    stub_classes 'Believable::Commentje', 'UserOpinionCalculation',
                 'Authority'
  end

  describe 'validation' do
    it 'with a invalid comment_id doesn\'t validate' do
      expect_validating(comment_id: 'g', fact: mock).
        to fail_validation 'comment_id should be an hexadecimal string.'
    end
  end

  describe '#call' do
    it "returns the opinion the calculator calculates" do
      opinion = mock
      calculator = mock(:calculator, opinion: opinion)
      query = described_class.new comment_id: 'a1', fact: mock

      query.stub calculator: calculator

      expect(query.call).to eq opinion
    end
  end

  describe '#calculator' do
    it "calls the UserOpinionCalculation with the authority_for" do
      believable = mock
      authority_block = Proc.new {|u| 1 }
      calculator = mock
      query = described_class.new comment_id: '1', fact: mock

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
      query = Queries::OpinionForComment.new comment_id: '1', fact: fact

      Authority.should_receive(:on)
               .with(fact, for: graph_user)
               .and_return(authority)

      expect(query.authority_for.call(graph_user)).to eq authority + 1
    end
  end

  describe '.believable' do
    it "returns the Believable::Commentje for this comment" do
      id = 'a1'
      believable = mock
      query = Queries::OpinionForComment.new comment_id: id, fact: mock

      Believable::Commentje.should_receive(:new)
                       .with(id)
                       .and_return(believable)

      expect(query.believable).to eq believable
    end
  end

end
