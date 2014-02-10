require 'pavlov_helper'
require_relative '../../../app/interactors/backend/comments'

describe Backend::Comments do
  include PavlovSupport

  before do
    stub_classes 'Believable::Commentje'
  end

  describe '.remove_opinion' do
    it "removes the opinion on the believable belonging to this commment" do
      believable = double :believable
      graph_user = double :graph_user
      comment_id = 'a1'

      Believable::Commentje.should_receive(:new)
                       .with(comment_id)
                       .and_return(believable)

      believable.should_receive(:remove_opinionateds)
                .with(graph_user)

      Backend::Comments.remove_opinion comment_id: comment_id, graph_user: graph_user
    end
  end

  describe ".set_opinion" do
    it "sets the opinion on the believable belonging to this comment" do
      opinion = 'believes'

      believable = double
      graph_user = double
      comment_id = 'a1'

      Believable::Commentje.should_receive(:new)
                       .with(comment_id)
                       .and_return(believable)

      believable.should_receive(:add_opiniated)
                .with(opinion, graph_user)

      Backend::Comments.set_opinion \
        comment_id: comment_id,
        opinion: opinion,
        graph_user: graph_user
    end
  end
end
