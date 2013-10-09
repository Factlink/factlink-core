class SubCommentsController < ApplicationController
  def index
    if parent_is_comment
      @sub_comments = interactor(:'sub_comments/index_for_comment', comment_id: parent_id)
    else
      @sub_comments = interactor(:'sub_comments/index_for_fact_relation', fact_relation_id: parent_id.to_i)
    end
    render 'sub_comments/index', formats: [:json]
  end

  def create
    if parent_is_comment
      @sub_comment = interactor(:'sub_comments/create_for_comment',
                                    comment_id: parent_id, content: params[:content])
    else
      @sub_comment = interactor(:'sub_comments/create_for_fact_relation',
                                    fact_relation_id: parent_id.to_i,
                                    content: params[:content])
    end
    render 'sub_comments/show', formats: [:json]
  rescue Pavlov::ValidationError
    render text: 'something went wrong', status: 400
  end

  def destroy
    @sub_comment = interactor(:'sub_comments/destroy', id: params[:sub_comment_id])
    render json: {}, status: :ok
  end

  def parent_is_comment
    params[:comment_id]
  end

  def parent_id
    params[:comment_id] || params[:id]
  end
end
