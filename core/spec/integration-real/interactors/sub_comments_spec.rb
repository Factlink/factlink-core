require 'spec_helper'

describe 'subcomments' do
  include PavlovSupport

  let(:current_user) { create :active_user }

  describe 'initially' do
    it 'a comment has no subcomments and can be deleted' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor(:'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {})
        comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'believes', content: "Gekke \n Gerrit")

        sub_comments = pavlov.interactor(:'sub_comments/index_for_comment', comment_id: comment.id.to_s)
        comments = pavlov.interactor(:'evidence/for_fact_id', fact_id: fact.id.to_s, type: :supporting)

        expect(sub_comments).to eq []
        expect(comments.map(&:can_destroy?)).to eq [true]
      end
    end
  end

  describe 'after adding a few subcomments to a comment' do
    it 'should have the subcomments we added and cannot be deleted' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor(:'facts/create', displaystring: "a fact", url: "", title: "", sharing_options: {})
        comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'believes', content: "Gekke \n Gerrit")

        sub_comment1 = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: "Gekke \n Gerrit")
        sub_comment2 = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'Handige Harrie')

        sub_comments = pavlov.interactor(:'sub_comments/index_for_comment', comment_id: comment.id.to_s)
        comments = pavlov.interactor(:'evidence/for_fact_id', fact_id: fact.id.to_s, type: :supporting)

        expect(sub_comments.map(&:content)).to eq ["Gekke \n Gerrit", 'Handige Harrie']
        expect(comments.map(&:can_destroy?)).to eq [false]
      end
    end

    describe "after removing one subcomment again" do
      it "should only contain the other comment" do
        as(current_user) do |pavlov|
          fact = pavlov.interactor(:'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {})
          comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'believes', content: "Gekke \n Gerrit")

          sub_comment1 = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: "Gekke \n Gerrit")
          sub_comment2 = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'Handige Harrie')

          pavlov.interactor(:'sub_comments/destroy', id: sub_comment1.id.to_s)

          sub_comments = pavlov.interactor(:'sub_comments/index_for_comment', comment_id: comment.id.to_s)
          expect(sub_comments.map(&:content)).to eq ['Handige Harrie']
        end
      end
    end
  end
  describe 'after adding a few subcomments to a fact_relation' do
    it "should only contain the sub_comments" do
      as(current_user) do |pavlov|
        fact = pavlov.interactor(:'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {})
        sub_fact = pavlov.interactor(:'facts/create', displaystring: 'a supporting fact', url: '', title: '', sharing_options: {})

        fact_relation = FactRelation.get_or_create(
          sub_fact, :supporting, fact, current_user.graph_user
        )

        sub_comment1 = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: "Gekke \n Gerrit")
        sub_comment2 = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'Handige Harrie')

        sub_comments = pavlov.interactor(:'sub_comments/index_for_fact_relation', fact_relation_id: fact_relation.id.to_i)
        expect(sub_comments.map(&:content)).to eq ["Gekke \n Gerrit", 'Handige Harrie']
      end
    end
  end
end
