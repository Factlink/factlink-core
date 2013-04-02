require 'spec_helper'

describe 'subcomments' do
  include PavlovSupport

  let(:current_user) { create :user }

  describe 'initially' do
    it 'has no subcomments and can be deleted' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor :'facts/create', 'a fact', '', ''
        comment = pavlov.interactor :'comments/create', fact.id.to_i, 'believes', 'Gekke Gerrit'

        sub_comments = pavlov.interactor :'sub_comments/index_for_comment', comment.id.to_s
        comments = pavlov.interactor :'evidence/for_fact_id', fact.id.to_s, :supporting

        expect(sub_comments).to eq []
        expect(comments.map(&:can_destroy?)).to eq [true]
      end
    end
  end

  describe 'after adding a few subcomments' do
    it 'should have the subcomments we added and cannot be deleted' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor :'facts/create', 'a fact', '', ''
        comment = pavlov.interactor :'comments/create', fact.id.to_i, 'believes', 'Gekke Gerrit'

        sub_comment1 = pavlov.interactor :'sub_comments/create_for_comment', comment.id.to_s, 'Gekke Gerrit'
        sub_comment2 = pavlov.interactor :'sub_comments/create_for_comment', comment.id.to_s, 'Handige Harrie'

        sub_comments = pavlov.interactor :'sub_comments/index_for_comment', comment.id.to_s
        comments = pavlov.interactor :'evidence/for_fact_id', fact.id.to_s, :supporting

        expect(sub_comments.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
        expect(comments.map(&:can_destroy?)).to eq [false]
      end
    end

    describe "after removing one subcomment again" do
      it "should only contain the other comment" do
        as(current_user) do |pavlov|
          fact = pavlov.interactor :'facts/create', 'a fact', '', ''
          comment = pavlov.interactor :'comments/create', fact.id.to_i, 'believes', 'Gekke Gerrit'

          sub_comment1 = pavlov.interactor :'sub_comments/create_for_comment', comment.id.to_s, 'Gekke Gerrit'
          sub_comment2 = pavlov.interactor :'sub_comments/create_for_comment', comment.id.to_s, 'Handige Harrie'

          pavlov.interactor :'sub_comments/destroy', sub_comment1.id.to_s

          sub_comments = pavlov.interactor :'sub_comments/index_for_comment', comment.id.to_s
          expect(sub_comments.map(&:content)).to eq ['Handige Harrie']
        end
      end
    end

  end
end
