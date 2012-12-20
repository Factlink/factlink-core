class SubCommentsController < ApplicationController
  def index
    @sub_comments = interactor :'sub_comments/index_for_fact_relation', params[:id].to_i
    render 'sub_comments/index'
  end

  def create
    @sub_comment = interactor :'sub_comments/create_for_fact_relation', params[:id].to_i, params[:content]
    render 'sub_comments/show'
  end

  def destroy
    @sub_comment = interactor :'sub_comments/destroy', params[:sub_comment_id]
    render json: {}, status: :ok
  end
end
