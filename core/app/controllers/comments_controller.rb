require_relative 'application_controller'

class CommentsController < ApplicationController
  def create
    fact_id = get_fact_id_param
    @comment = old_interactor :"comments/create", fact_id, type, params[:content]

    render 'comments/show', formats: [:json]
  rescue Pavlov::ValidationError => e

    render text: e.message, :status => 400
  end

  def destroy
    comment_id = get_comment_id_param
    old_interactor :"comments/delete", comment_id

    render :json => {}, :status => :ok
  end

  def update
    @comment = old_interactor 'comments/update_opinion', get_comment_id_param, params[:opinion]

    render 'comments/show', formats: [:json]
  end

  def sub_comments_index
    @sub_comments = old_interactor :'sub_comments/index_for_comment', get_comment_id_param

    render 'sub_comments/index', formats: [:json]
  end

  def sub_comments_create
    @sub_comment = old_interactor :'sub_comments/create_for_comment', get_comment_id_param, params[:content]

    render 'sub_comments/show', formats: [:json]
  end

  private

  def get_fact_id_param
    id_string = params[:id]
    raise 'No Fact id is supplied.' if id_string == nil

    id = id_string.to_i
    raise 'No valid Fact id is supplied.' if id == 0

    id
  end

  def get_comment_id_param
    id_string = params[:id]
    raise 'No Comment id is supplied.' if id_string == nil

    id_string
  end

  def type
    case params[:type]
    when 'supporting' then 'believes'
    when 'weakening' then 'disbelieves'
    else params[:type]
    end
  end
end
