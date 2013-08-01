require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/comments/set_opinion.rb'

describe Commands::Comments::SetOpinion do
  include PavlovSupport

  before do
    stub_classes 'Believable::Commentje'
  end

  describe '#call' do
    it "sets the opinion on the believable belonging to this comment" do
      opinion = 'believes'

      believable = double
      graph_user = double

      command = described_class.new comment_id: 'a1', opinion: opinion, graph_user: double
      command.stub believable: believable,
                   graph_user: graph_user


      believable.should_receive(:add_opiniated)
                .with(opinion, graph_user)
      command.call
    end
  end

  describe '.believable' do
    it "returns the Believable::Commentje for this comment" do
      id = 'a1'
      believable = double
      command = described_class.new comment_id: id, opinion:'believes', graph_user: double

      Believable::Commentje.should_receive(:new)
                       .with(id)
                       .and_return(believable)

      expect(command.believable).to eq believable
    end
  end

  describe '.graph_user' do
    it "returns the graph_user passed in" do
      graph_user = double
      command = described_class.new comment_id: 'a1', opinion:'believes', graph_user: graph_user
      expect(command.graph_user).to eq graph_user
    end
  end
end
