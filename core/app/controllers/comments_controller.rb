class CommentsController < ApplicationController
  def index
    fact_id = params[:id]
    comments = interactor(:'comments/for_fact_id', fact_id: fact_id)
    render json: {
      username: current_user && current_user.username,
      comments: comments
    }
  end

  def create
    render json: interactor(:'comments/create', fact_id: params[:id], content: params[:content], format: params[:format] || nil)
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
end
