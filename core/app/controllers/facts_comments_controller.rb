require_relative 'application_controller'

class FactsCommentsController < ApplicationController
  respond_to :json

  def create
    fact_id = get_fact_id_param
    interactor :create_comment_for_fact, fact_id, params[:opnion], params[:content]
  end

  def destroy
    comment_id = get_comment_id_param
    interactor :delete_comment_for_fact, comment_id
  end

  private
    def get_fact_id_param
      id_string = params[:fact_id] || params[:id]
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
      id_string = params[:comment_id]
      if id_string == nil
        raise 'No Comment id is supplied.'
      end

      id
    end
end
