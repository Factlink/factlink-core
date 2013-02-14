require 'spec_helper'

describe EvidenceDeletable do

  context 'Comment' do
    let(:created_by_user) {create :active_user}
    let(:other_user)      {create :active_user}
    let(:fact_user)       {create :active_user}
    let(:fact)            {create :fact, created_by: fact_user.graph_user}

    let(:comment) do
      interactor = Interactors::Comments::Create.new(fact.id.to_i, 'believes', 'content', current_user: created_by_user)
      dead_comment = interactor.execute
      Comment.find(dead_comment.id)
    end

    def deletable comment
      EvidenceDeletable.new(comment, 'Comment', believable_of(comment),
        comment.created_by.graph_user_id).deletable?
    end

    def add_opinion comment, opinion, graph_user
      believable_of(comment).add_opiniated(opinion, graph_user)
    end

    def believable_of comment
      Believable::Commentje.new(comment)
    end

    it "should be true initially" do
      deletable(comment).should be_true
    end
    it "should be true if only the creator believes it" do
      add_opinion(comment, :believes, comment.created_by.graph_user)
      deletable(comment).should be_true
    end
    it "should be false after someone else believes the relation" do
      add_opinion(comment, :believes, other_user.graph_user)
      deletable(comment).should be_false
    end
    it "should be true if only the creator believes it" do
      add_opinion(comment, :disbelieves, other_user.graph_user)
      deletable(comment).should be_true
    end
    it "should be true if only the creator believes it" do
      add_opinion(comment, :doubts, other_user.graph_user)
      deletable(comment).should be_true
    end
    it "should be false after someone comments on it" do
      interactor = Interactors::SubComments::CreateForComment.new comment.id.to_s, 'hoi', current_user: comment.created_by
      interactor.execute
      deletable(comment).should be_false
    end
  end

end
