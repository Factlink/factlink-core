require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/graph_user_opinion'

describe Queries::Comments::GraphUserOpinion do
  include PavlovSupport
  before do
    stub_classes 'OpinionType', 'Believable::Commentje'
  end

  describe '#call' do
    it 'retrieves the current opinion for the graphuser' do
      id = 'a1'
      graph_user = double
      op1, op2 = double, double
      query = described_class.new comment_id: id, graph_user: graph_user

      query.stub possible_opinions: [op1, op2]
      query.stub!(:has_opinion?) {|type| type == op2}

      expect(query.call).to eq op2
    end
  end

  describe '#possible_opinions' do
    it 'should use Opinion.types' do
      id = 'a1'
      graph_user = double
      types = double
      query = described_class.new comment_id: id, graph_user: graph_user

      OpinionType.stub types: types

      expect(query.possible_opinions).to eq types
    end
  end

  describe '#has_opinion?' do
    it 'should ask the people with this opinion if they include the graph_user' do
      id = 'a1'
      graph_user = double

      query = described_class.new comment_id: id, graph_user: graph_user

      opinion = double
      opiniated = double
      answer = double

      query.should_receive(:people_who_believe).with(opinion)
           .and_return(opiniated)
      opiniated.should_receive(:include?).with(graph_user)
               .and_return(answer)

      expect(query.has_opinion?(opinion)).to eq answer
    end
  end

  describe '.people_who_believe' do
    it "should retrieve the people who believe something from believable" do
      id = 'a1'
      graph_user = double
      believable = double
      opinion = double
      answer = double

      query = described_class.new comment_id: id, graph_user: graph_user
      query.stub believable: believable
      believable.should_receive(:opiniated).with(opinion)
                .and_return(answer)

      expect(query.people_who_believe(opinion)).to eq answer
    end
  end

  describe '#believable' do
    it 'retrieves a cached Believable object for the comment' do
      id = 'a1'
      graph_user = double
      query = described_class.new comment_id: id, graph_user: graph_user
      believable = double

      Believable::Commentje.should_receive(:new).once
         .with(id).and_return(believable)

      expect(query.believable).to eq believable
      expect(query.believable).to eq believable
    end
  end
end
