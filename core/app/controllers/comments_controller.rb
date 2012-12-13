require_relative 'application_controller'

class CommentsController < ApplicationController
  def create
    fact_id = get_fact_id_param
    @comment = interactor :"comments/create", fact_id, params[:type], params[:content]

    render 'comments/show'
  end

  def destroy
    comment_id = get_comment_id_param
    interactor :"comments/delete", comment_id

    render :json => {}, :status => :ok
  end

  def index
    fact_id = get_fact_id_param
    type    = params[:type].to_s

    comments = interactor :"comments/index", fact_id, type

    @comments = sort_by_relevance comments

    render 'comments/index'
  end

  def update
    @comment = interactor 'comments/update_opinion', get_comment_id_param, params[:opinion]

    render 'comments/show'
  end

  private
    def get_fact_id_param
      id_string = params[:id]
      if id_string == nil
        raise 'No Fact id is supplied.'
      end

      id = id_string.to_i
      if id == 0
        raise 'No valid Fact id is supplied.'
      end

      id
    end

    def get_comment_id_param
      id_string = params[:id]
      if id_string == nil
        raise 'No Comment id is supplied.'
      end

      id_string
    end

    def sort_by_relevance comments
      comments.sort do |a,b|
        OpinionPresenter.new(a.opinion).relevance <=> OpinionPresenter.new(b.opinion).relevance
      end
    end
end
