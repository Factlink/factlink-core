require 'spec_helper'

describe 'subcomments' do
  include PavlovSupport

  let(:current_user) { create :user }

  describe 'initially' do
    it 'a comment has no subcomments and can be deleted' do
      as(current_user) do |pavlov|
        fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
        comment = pavlov.old_interactor :'comments/create', fact.id.to_i, 'believes', "Gekke \n Gerrit"

        sub_comments = pavlov.old_interactor :'sub_comments/index_for_comment', comment.id.to_s
        comments = pavlov.old_interactor :'evidence/for_fact_id', fact.id.to_s, :supporting

        expect(sub_comments).to eq []
        expect(comments.map(&:can_destroy?)).to eq [true]
      end
    end
  end

  describe 'after adding a few subcomments to a comment' do
    it 'should have the subcomments we added and cannot be deleted' do
      as(current_user) do |pavlov|
        fact = pavlov.old_interactor :'facts/create', "a fact", "", "", {}
        comment = pavlov.old_interactor :'comments/create', fact.id.to_i, 'believes', "Gekke \n Gerrit"

        sub_comment1 = pavlov.old_interactor :'sub_comments/create_for_comment', comment.id.to_s, "Gekke \n Gerrit"
        sub_comment2 = pavlov.old_interactor :'sub_comments/create_for_comment', comment.id.to_s, 'Handige Harrie'

        sub_comments = pavlov.old_interactor :'sub_comments/index_for_comment', comment.id.to_s
        comments = pavlov.old_interactor :'evidence/for_fact_id', fact.id.to_s, :supporting

        expect(sub_comments.map(&:content)).to eq ["Gekke \n Gerrit", 'Handige Harrie']
        expect(comments.map(&:can_destroy?)).to eq [false]
      end
    end

    describe "after removing one subcomment again" do
      it "should only contain the other comment" do
        as(current_user) do |pavlov|
          fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
          comment = pavlov.old_interactor :'comments/create', fact.id.to_i, 'believes', "Gekke \n Gerrit"

          sub_comment1 = pavlov.old_interactor :'sub_comments/create_for_comment', comment.id.to_s, "Gekke \n Gerrit"
          sub_comment2 = pavlov.old_interactor :'sub_comments/create_for_comment', comment.id.to_s, 'Handige Harrie'

          pavlov.old_interactor :'sub_comments/destroy', sub_comment1.id.to_s

          sub_comments = pavlov.old_interactor :'sub_comments/index_for_comment', comment.id.to_s
          expect(sub_comments.map(&:content)).to eq ['Handige Harrie']
        end
      end
    end
  end
  describe 'after adding a few subcomments to a fact_relation' do
    it "should only contain the sub_comments" do
      as(current_user) do |pavlov|
        fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
        sub_fact = pavlov.old_interactor :'facts/create', 'a supporting fact', '', '', {}

        fact_relation = FactRelation.get_or_create(
          sub_fact, :supporting, fact, current_user.graph_user
        )

        sub_comment1 = pavlov.old_interactor :'sub_comments/create_for_fact_relation', fact_relation.id.to_i, "Gekke \n Gerrit"
        sub_comment2 = pavlov.old_interactor :'sub_comments/create_for_fact_relation', fact_relation.id.to_i, 'Handige Harrie'

        sub_comments = pavlov.old_interactor :'sub_comments/index_for_fact_relation', fact_relation.id.to_i
        expect(sub_comments.map(&:content)).to eq ["Gekke \n Gerrit", 'Handige Harrie']
      end
    end
  end
end
