class SubCommentsController < ApplicationController
  def index
    if parent_is_comment
      @sub_comments = interactor :'sub_comments/index_for_comment', parent_id
    else
      @sub_comments = interactor :'sub_comments/index_for_fact_relation', parent_id.to_i
    end
    render 'sub_comments/index'
  rescue Pavlov::ValidationError => e
    render text: e.message, :status => 400
  end

  def create
    if parent_is_comment
      @sub_comment = interactor :'sub_comments/create_for_comment', parent_id, params[:content]
    else
      @sub_comment = interactor :'sub_comments/create_for_fact_relation', parent_id.to_i, params[:content]
    end
    render 'sub_comments/show'
  end

  def destroy
    @sub_comment = interactor :'sub_comments/destroy', params[:sub_comment_id]
    render json: {}, status: :ok
  end

  def parent_is_comment
    params[:comment_id]
  end

  def parent_id
    params[:comment_id] || params[:id]
  end
end
