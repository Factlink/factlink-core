require 'spec_helper'

describe 'comments' do
  include PavlovSupport

  let(:current_user) { create :user }

  describe 'initially' do
    it 'a fact has no comments' do
      as(current_user) do |pavlov|
        dead_fact = pavlov.interactor :'facts/create', displaystring: 'a fact', site_url: 'http://example.org', site_title: ''

        comments = pavlov.interactor :'comments/for_fact_id', fact_id: dead_fact.id.to_s

        expect(comments).to eq []
      end
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add, sorted by votes' do
      as(current_user) do |pavlov|
        dead_fact = pavlov.interactor :'facts/create', displaystring: 'a fact', site_url: 'http://example.org', site_title: ''

        comment1 = pavlov.interactor :'comments/create', fact_id: dead_fact.id, content: 'Gekke Gerrit'
        comment2 = pavlov.interactor :'comments/create', fact_id: dead_fact.id, content: 'Handige Harrie'

        pavlov.interactor :'comments/update_opinion', comment_id: comment1.id.to_s, opinion: 'disbelieves'

        comments = pavlov.interactor :'comments/for_fact_id', fact_id: dead_fact.id.to_s

        expect(comments.map(&:formatted_content)).to eq [comment2.formatted_content, comment1.formatted_content]
      end
    end
  end

  it "removing a few comments" do
    as(current_user) do |pavlov|
      fact = pavlov.interactor :'facts/create', displaystring: 'a fact', site_url: 'http://example.org', site_title: ''

      comment1 = pavlov.interactor :'comments/create', fact_id: fact.id, content: 'Gekke Gerrit'
      comment2 = pavlov.interactor :'comments/create', fact_id: fact.id, content: 'Handige Harrie'
      pavlov.interactor :'comments/delete', comment_id: comment1.id.to_s

      comments = pavlov.interactor :'comments/for_fact_id', fact_id: fact.id.to_s

      expect(comments.map(&:formatted_content)).to eq [comment2.formatted_content]
    end
  end

  it "updating comment" do
    as(current_user) do |pavlov|
      fact = pavlov.interactor :'facts/create', displaystring: 'a fact', site_url: 'http://example.org', site_title: ''

      updated_content = 'Handige Harrie'
      comment = pavlov.interactor :'comments/create', fact_id: fact.id, content: 'Gekke Gerrit'
      pavlov.interactor :'comments/update', comment_id: comment.id.to_s, content: updated_content

      comments = pavlov.interactor :'comments/for_fact_id', fact_id: fact.id.to_s

      expect(comments.map(&:formatted_content)).to eq [updated_content]
    end
  end
end
