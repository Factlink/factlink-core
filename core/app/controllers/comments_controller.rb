require_relative 'application_controller'

class CommentsController < ApplicationController
  def create
    fact_id = Integer(params[:id])
    type = params[:type]
    @comment = interactor(:'comments/create', fact_id: fact_id, type: type,
                                              content: params[:content])

    render 'comments/show', formats: [:json]
  rescue Pavlov::ValidationError
    render text: 'something went wrong', :status => 400
  end

  def destroy
    interactor :'comments/delete', comment_id: params[:id].to_str

    render :json => {}, :status => :ok
  end

  def update_opinion
    @comment = interactor(:'comments/update_opinion',
                              comment_id: params[:id].to_str,
                              opinion: params[:current_user_opinion])

    render json: {}
  end

  def sub_comments_index
    @sub_comments = interactor(:'sub_comments/index_for_comment',
                                   comment_id: params[:id].to_str)

    render 'sub_comments/index', formats: [:json]
  end

  def sub_comments_create
    @sub_comment = interactor(:'sub_comments/create_for_comment',
                                  comment_id: params[:id].to_str,
                                  content: params[:content])

    render 'sub_comments/show', formats: [:json]
  end
end
