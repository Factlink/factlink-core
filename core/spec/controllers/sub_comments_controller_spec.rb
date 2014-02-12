require 'spec_helper'

describe SubCommentsController do
  let (:user)  { create :full_user }

  render_views

  describe "#index" do
    include PavlovSupport
    before do
      as(user) do |p|
        @fact = create :fact
        @comment = p.interactor(:'comments/create', fact_id: @fact.id.to_i, content:'yo')
        p.interactor(:'sub_comments/create_for_comment',
                      comment_id: @comment.id.to_s, content: 'hey')
      end
      as(create :user) do |p|
        p.interactor(:'sub_comments/create_for_comment',
                      comment_id: @comment.id.to_s, content: 'meh')
      end
    end

    it 'works' do
      authenticate_user!(user)

      get :index, id: @fact.id, comment_id: @comment.id

      expect(response).to be_success
      verify(format: :json) { response.body }
    end
  end
end
