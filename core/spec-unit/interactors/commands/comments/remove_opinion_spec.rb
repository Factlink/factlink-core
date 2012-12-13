require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/comments/remove_opinion'

describe Commands::Comments::RemoveOpinion do
  include PavlovSupport

  before do
    stub_classes 'Believable::Comment'
  end

  describe '.execute' do
    it "removes the opinion on the believable belonging to this commment" do
      believable = mock
      graph_user = mock

      command = Commands::Comments::RemoveOpinion.new 'a1', mock
      command.stub believable: believable,
                   graph_user: graph_user

      believable.should_receive(:remove_opinionateds)
                .with(graph_user)
      command.execute
    end
  end

  describe '.believable' do
    it "returns the Believable::Comment for this comment" do
      id = 'a1'
      believable = mock
      command = Commands::Comments::RemoveOpinion.new id, mock

      Believable::Comment.should_receive(:new)
                       .with(id)
                       .and_return(believable)

      expect(command.believable).to eq believable
    end
  end

  describe '.graph_user' do
    it "returns the graph_user passed in" do
      graph_user = mock
      command = Commands::Comments::RemoveOpinion.new 'a1', graph_user
      expect(command.graph_user).to eq graph_user
    end
  end
end
