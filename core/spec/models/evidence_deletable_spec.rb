require 'spec_helper'

describe EvidenceDeletable do
  include PavlovSupport

  context 'Comment' do
    let(:created_by_user) { create :full_user }
    let(:fact)            { create :fact }

    let(:comment) do
      dead_comment = as(created_by_user) do |context|
        context.interactor(:'comments/create',
                           fact_id: fact.id.to_i,
                           type: 'believes',
                           content: 'content')
      end
      Comment.find(dead_comment.id)
    end

    it "should be true initially" do
      EvidenceDeletable.deletable?(comment).should be_true
    end
    it "should be false after someone comments on it" do
      as(created_by_user) do |context|
        context.interactor(:'sub_comments/create',
                           comment_id: comment.id.to_s,
                           content: 'hoi')
      end
      EvidenceDeletable.deletable?(comment).should be_false
    end
  end

end
