class SubCommentsController < ApplicationController
  def index
    @sub_comments = interactor(:'sub_comments/index_for_comment', comment_id: comment_id)
    render 'sub_comments/index', formats: [:json]
  end

  def create
    @sub_comment = interactor(:'sub_comments/create_for_comment',
                                  comment_id: comment_id, content: params[:content])
    render 'sub_comments/show', formats: [:json]
  rescue Pavlov::ValidationError
    render text: 'something went wrong', status: 400
  end

  def destroy
    @sub_comment = interactor(:'sub_comments/destroy', id: params[:sub_comment_id])
    render json: {}, status: :ok
  end

  def comment_id
    params[:comment_id]
  end
end
