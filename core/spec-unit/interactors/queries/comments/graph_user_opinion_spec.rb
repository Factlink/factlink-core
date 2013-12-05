require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/graph_user_opinion'

describe Queries::Comments::GraphUserOpinion do
  include PavlovSupport
  before do
    stub_classes 'Believable::Commentje'
  end

  describe '#call' do
    it "retrieves the current opinion for the graph_user" do
      id = 'a1'
      graph_user = double
      believable = double
      opinion = :believes
      query = described_class.new comment_id: id, graph_user: graph_user

      Believable::Commentje.stub(:new).with(id).and_return(believable)
      believable.stub(:opinion_of_graph_user).with(graph_user).and_return(opinion)

      expect(query.call).to eq :believes
    end
  end
end
