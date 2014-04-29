require 'spec_helper'

describe SubCommentsController do
  let (:user)  { create :user }

  render_views

  describe "#index" do
    include PavlovSupport
    before do
      FactoryGirl.reload

      as(user) do |p|
        @fact_data = create :fact_data
        @comment = p.interactor(:'comments/create', fact_id: @fact_data.fact_id.to_s, content:'yo')
        p.interactor(:'sub_comments/create',
                      comment_id: @comment.id.to_s, content: 'hey')
      end
      as(create :user) do |p|
        p.interactor(:'sub_comments/create',
                      comment_id: @comment.id.to_s, content: 'meh')
      end
    end

    it 'works' do
      authenticate_user!(user)

      get :index, id: @fact_data.fact_id.to_s, comment_id: @comment.id

      expect(response).to be_success
      verify { response.body }
    end
  end
end
