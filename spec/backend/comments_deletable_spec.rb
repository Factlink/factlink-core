require 'spec_helper'

describe Backend::Comments do
  include PavlovSupport

  context 'Comment' do
    let(:user) { create :user }
    let(:fact_data) { create :fact_data }

    let(:comment) do
      dead_comment = as(user) do |context|
        context.interactor(:'comments/create',
                           fact_id: fact_data.fact_id.to_s,
                           type: 'believes',
                           content: 'content')
      end
      Comment.find(dead_comment.id)
    end

    it "should be true initially" do
      Backend::Comments.deletable?(comment.id).should be_true
    end

    it "should be false after someone comments on it" do
      as(user) do |context|
        context.interactor(:'sub_comments/create',
                           comment_id: comment.id.to_s,
                           content: 'hoi')
      end
      Backend::Comments.deletable?(comment.id).should be_false
    end
  end

end
