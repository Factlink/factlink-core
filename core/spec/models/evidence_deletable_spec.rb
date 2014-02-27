require 'spec_helper'

describe EvidenceDeletable do

  context 'Comment' do
    let(:created_by_user) { create :full_user }
    let(:fact)            { create :fact }

    let(:comment) do
      pavlov_options = {
        current_user: created_by_user,
        ability: Ability.new(created_by_user)
      }
      interactor = Interactors::Comments::Create.new(fact_id: fact.id.to_i,
                                                     type: 'believes', content: 'content', pavlov_options:pavlov_options )
      dead_comment = interactor.call
      Comment.find(dead_comment.id)
    end

    it "should be true initially" do
      EvidenceDeletable.deletable?(comment).should be_true
    end
    it "should be false after someone comments on it" do
      pavlov_options = {
        current_user: created_by_user,
        ability: Ability.new(created_by_user)
      }

      interactor = Interactors::SubComments::Create.new(comment_id: comment.id.to_s,
                                                        content: 'hoi', pavlov_options: pavlov_options)
      interactor.execute
      EvidenceDeletable.deletable?(comment).should be_false
    end
  end

end
