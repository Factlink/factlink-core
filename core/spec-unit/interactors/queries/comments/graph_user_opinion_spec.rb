require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/graph_user_opinion'

describe Queries::Comments::GraphUserOpinion do
  include PavlovSupport
  before do
    stub_classes 'Opinion', 'Believable::Commentje'
  end

  describe '.execute' do
    it "retrieves the current opinion for the graphuser" do
      id = 'a1'
      graph_user = mock
      op1, op2 = mock, mock

      query = Queries::Comments::GraphUserOpinion.new id, graph_user
      query.stub possible_opinions: [op1, op2]
      query.stub!(:has_opinion?) {|type| type == op2}
      expect(query.execute).to eq op2
    end
  end

  describe '.possible_opinions' do
    it "should use Opinion.types" do
      id = 'a1'
      graph_user = mock
      types = mock

      query = Queries::Comments::GraphUserOpinion.new id, graph_user

      Opinion.stub types: types

      expect(query.possible_opinions).to eq types
    end
  end

  describe '.has_opinion?' do
    it "should ask the people with this opinion if they include the graph_user" do
      id = 'a1'
      graph_user = mock

      query = Queries::Comments::GraphUserOpinion.new id, graph_user

      opinion = mock
      opiniated = mock
      answer = mock

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
      graph_user = mock
      believable = mock
      opinion = mock
      answer = mock

      query = Queries::Comments::GraphUserOpinion.new id, graph_user
      query.stub believable: believable
      believable.should_receive(:opiniated).with(opinion)
                .and_return(answer)

      expect(query.people_who_believe(opinion)).to eq answer
    end
  end

  describe '.believable' do

    it "retrieves a cached Believable object for the comment" do
      id = 'a1'
      graph_user = mock
      query = Queries::Comments::GraphUserOpinion.new id, graph_user
      believable = mock

      Believable::Commentje.should_receive(:new).once
         .with(id).and_return(believable)

      expect(query.believable).to eq believable
      expect(query.believable).to eq believable
    end
  end
end
