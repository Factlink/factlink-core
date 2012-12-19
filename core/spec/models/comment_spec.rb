require 'spec_helper'

describe Comment do

  describe :deletable? do
    let(:created_by_user) {create :approved_confirmed_user}
    let(:other_user)      {create :approved_confirmed_user}
    let(:fact)            {create :fact}

    let(:comment) do
      interactor = Interactors::Comments::Create.new(fact.id.to_i, 'believes', 'content', current_user: created_by_user)
      dead_comment = interactor.execute
      Comment.find(dead_comment.id)
    end

    def add_opinion comment, opinion, graph_user
      Believable::Commentje.new(comment).add_opiniated(opinion, graph_user)
    end

    it "should be true initially" do
      comment.deletable?.should be_true
    end
    it "should be true if only the creator believes it" do
      add_opinion(comment, :believes, comment.created_by.graph_user)
      comment.deletable?.should be_true
    end
    it "should be false after someone else believes the relation" do
      add_opinion(comment, :believes, other_user.graph_user)
      comment.deletable?.should be_false
    end
    it "should be true if only the creator believes it" do
      add_opinion(comment, :disbelieves, other_user.graph_user)
      comment.deletable?.should be_true
    end
    it "should be true if only the creator believes it" do
      add_opinion(comment, :doubts, other_user.graph_user)
      comment.deletable?.should be_true
    end
    it "should be false after someone comments on it" do
      interactor = Interactors::SubComments::CreateForComment.new comment.id.to_s, 'hoi', current_user: comment.created_by
      interactor.execute
      comment.deletable?.should be_false
    end
  end

end
