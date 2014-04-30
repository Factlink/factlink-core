require 'spec_helper'

describe CommentsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :index do
    it "should render json successful" do
      FactoryGirl.reload

      other_user = create(:user)

      authenticate_user!(user)
      dead_fact = nil

      as(user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     site_url: 'url',
                                     site_title: 'title')
      end
      as(other_user) do |pavlov|
        pavlov.interactor(:'comments/create', fact_id: dead_fact.id, content: 'a comment')
      end

      as(user) do |pavlov|
        comment = pavlov.interactor(:'comments/create', fact_id: dead_fact.id, content: 'a comment')
        pavlov.interactor(:'comments/update_opinion', comment_id: comment.id.to_s, opinion: 'disbelieves')
      end

      get :index, id: dead_fact.id, format: :json

      verify { response.body }
    end
  end

  describe :create do
    it "should return the correct json" do
      FactoryGirl.reload

      authenticate_user!(user)
      dead_fact = nil

      as(user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     site_url: 'url',
                                     site_title: 'title')
      end

      post :create, id: dead_fact.id, content: 'Gerard is een gekke meneer', markup_format: 'plaintext', format: :json

      verify { response.body }
    end
  end

  describe :create do
    it "returns a formatted anecdote" do
      FactoryGirl.reload

      authenticate_user!(user)
      dead_fact = nil

      as(user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     site_url: 'url',
                                     site_title: 'title')
      end

      anecdote = {
        introduction: 'Some introduction',
        insight: 'Some insight',
        resources: 'Some resources',
        actions: 'Some actions',
        effect: 'Some effect',
      }

      post :create, id: dead_fact.id, content: anecdote.to_json, markup_format: 'anecdote', format: :json

      verify { response.body }
    end
  end
end
