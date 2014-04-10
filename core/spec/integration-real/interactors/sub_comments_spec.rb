require 'spec_helper'

describe 'subcomments' do
  include PavlovSupport

  let(:current_user) { create :user }

  describe 'initially' do
    it 'a comment has no subcomments and can be deleted' do
      as(current_user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create', displaystring: 'a fact', site_url: 'http://example.org', site_title: '')
        comment = pavlov.interactor(:'comments/create', fact_id: dead_fact.id, type: 'believes', content: "Gekke \n Gerrit")

        sub_comments = pavlov.interactor(:'sub_comments/index_for_comment', comment_id: comment.id.to_s)
        comments = pavlov.interactor(:'comments/for_fact_id', fact_id: dead_fact.id.to_s, type: :believes)

        expect(sub_comments).to eq []
        expect(comments.map(&:is_deletable)).to eq [true]
      end
    end
  end

  describe 'after adding a few subcomments to a comment' do
    it 'should have the subcomments we added and cannot be deleted' do
      as(current_user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create', displaystring: "a fact", site_url: "http://example.org", site_title: "",)
        comment = pavlov.interactor(:'comments/create', fact_id: dead_fact.id, type: 'believes', content: "Gekke \n Gerrit")

        pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: "Gekke \n Gerrit")
        pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'Handige Harrie')

        sub_comments = pavlov.interactor(:'sub_comments/index_for_comment', comment_id: comment.id.to_s)
        comments = pavlov.interactor(:'comments/for_fact_id', fact_id: dead_fact.id.to_s, type: :believes)

        expect(sub_comments.map(&:content)).to eq ["Gekke \n Gerrit", 'Handige Harrie']
        expect(comments.map(&:is_deletable)).to eq [false]
      end
    end

    describe "after removing one subcomment again" do
      it "should only contain the other comment" do
        as(current_user) do |pavlov|
          dead_fact = pavlov.interactor(:'facts/create', displaystring: 'a fact', site_url: 'http://example.org', site_title: '')
          comment = pavlov.interactor(:'comments/create', fact_id: dead_fact.id, type: 'believes', content: "Gekke \n Gerrit")

          sub_comment1 = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: "Gekke \n Gerrit")
          sub_comment2 = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'Handige Harrie')

          pavlov.interactor(:'sub_comments/destroy', id: sub_comment1.id.to_s)

          sub_comments = pavlov.interactor(:'sub_comments/index_for_comment', comment_id: comment.id.to_s)
          expect(sub_comments.map(&:content)).to eq ['Handige Harrie']
        end
      end
    end
  end
end
