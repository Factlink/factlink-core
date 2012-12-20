require 'spec_helper'

describe 'subcomments' do
  include Pavlov::Helpers

  let(:current_user) { create :user }

  def pavlov_options
    {current_user: current_user}
  end

  describe 'commenting on a comment on a fact' do
    before do
      @fact = create :fact, created_by: create(:user).graph_user

      @comment = interactor :'comments/create', @fact.id.to_i, 'believes', 'Gekke Gerrit'
    end

    describe 'initially' do
      it 'has no subcomments' do
        sub_comments = interactor :'sub_comments/index_for_comment', @comment.id.to_s

        expect(sub_comments).to eq []
      end

      it 'can be deleted' do
        comments = interactor :'evidence/for_fact_id', @fact.id.to_s, :supporting

        expect(comments.map(&:can_destroy?)).to eq [true]
      end
    end

    describe 'after adding a few subcomments' do
      before do
        @sub_comment1 = interactor :'sub_comments/create_for_comment', @comment.id.to_s, 'Gekke Gerrit'
        @sub_comment2 = interactor :'sub_comments/create_for_comment', @comment.id.to_s, 'Handige Harrie'
      end

      it 'should have the subcomments we added' do
        sub_comments = interactor :'sub_comments/index_for_comment', @comment.id.to_s

        expect(sub_comments.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
      end

      describe "after removing on subcomment again" do
        it "should only contain the other comment" do
          interactor :'sub_comments/destroy', @sub_comment1.id.to_s

          sub_comments = interactor :'sub_comments/index_for_comment', @comment.id.to_s
          expect(sub_comments.map(&:content)).to eq ['Handige Harrie']
        end
      end

      it 's parent cannot be deleted any more' do
        comments = interactor :'evidence/for_fact_id', @fact.id.to_s, :supporting

        expect(comments.map(&:can_destroy?)).to eq [false]
      end
    end
  end
end
