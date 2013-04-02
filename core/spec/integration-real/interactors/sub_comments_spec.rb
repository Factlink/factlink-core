require 'spec_helper'

describe 'subcomments' do
  include PavlovSupport

  let(:current_user) { create :user }

  describe 'commenting on a comment on a fact' do
    before do
      @fact = create :fact, created_by: create(:user).graph_user
      as(current_user) do |pavlov|
        @comment = pavlov.interactor :'comments/create', @fact.id.to_i, 'believes', 'Gekke Gerrit'
      end
    end

    describe 'initially' do
      it 'has no subcomments' do
        as(current_user) do |pavlov|
          sub_comments = pavlov.interactor :'sub_comments/index_for_comment', @comment.id.to_s

          expect(sub_comments).to eq []
        end
      end

      it 'can be deleted' do
        as(current_user) do |pavlov|
          comments = pavlov.interactor :'evidence/for_fact_id', @fact.id.to_s, :supporting

          expect(comments.map(&:can_destroy?)).to eq [true]
        end
      end
    end

    describe 'after adding a few subcomments' do
      before do
        as(current_user) do |pavlov|
          @sub_comment1 = pavlov.interactor :'sub_comments/create_for_comment', @comment.id.to_s, 'Gekke Gerrit'
          @sub_comment2 = pavlov.interactor :'sub_comments/create_for_comment', @comment.id.to_s, 'Handige Harrie'
        end
      end

      it 'should have the subcomments we added' do
        as(current_user) do |pavlov|
          sub_comments = pavlov.interactor :'sub_comments/index_for_comment', @comment.id.to_s

          expect(sub_comments.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
        end
      end

      describe "after removing on subcomment again" do
        it "should only contain the other comment" do
          as(current_user) do |pavlov|
            pavlov.interactor :'sub_comments/destroy', @sub_comment1.id.to_s

            sub_comments = pavlov.interactor :'sub_comments/index_for_comment', @comment.id.to_s
            expect(sub_comments.map(&:content)).to eq ['Handige Harrie']
          end
        end
      end

      it 's parent cannot be deleted any more' do
        as(current_user) do |pavlov|
          comments = pavlov.interactor :'evidence/for_fact_id', @fact.id.to_s, :supporting

          expect(comments.map(&:can_destroy?)).to eq [false]
        end
      end
    end
  end
end
