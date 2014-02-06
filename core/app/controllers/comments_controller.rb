class CommentsController < ApplicationController
  def index
    fact_id = params[:id]
    @comments = interactor(:'comments/for_fact_id', fact_id: fact_id)

    render 'index', formats: [:json]
  end

  def create
    fact_id = Integer(params[:id])
    @comment = interactor(:'comments/create', fact_id: fact_id, content: params[:content])

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
end
