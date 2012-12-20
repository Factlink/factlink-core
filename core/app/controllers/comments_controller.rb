require_relative 'application_controller'

class CommentsController < ApplicationController
  def create
    fact_id = get_fact_id_param
    @comment = interactor :"comments/create", fact_id, type, params[:content]

    render 'comments/show'
  rescue Pavlov::ValidationError => e
    render text: e.message, :status => 400
  end

  def destroy
    comment_id = get_comment_id_param
    interactor :"comments/delete", comment_id

    render :json => {}, :status => :ok
  end

  def update
    @comment = interactor 'comments/update_opinion', get_comment_id_param, params[:opinion]

    render 'comments/show'
  end

  def sub_comments_index
    @sub_comments = interactor :'sub_comments/index_for_comment', get_comment_id_param
    render 'sub_comments/index'
  end

  def sub_comments_create
    @sub_comment = interactor :'sub_comments/create_for_comment', get_comment_id_param, params[:content]
    render 'sub_comments/show'
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
        OpinionPresenter.new(b.opinion).relevance <=> OpinionPresenter.new(a.opinion).relevance
      end
    end

    def type
      case params[:type]
      when 'supporting' then 'believes'
      when 'weakening' then 'disbelieves'
      else params[:type]
      end
    end
end
