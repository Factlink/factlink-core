class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def show
    backbone_responder
  end

  def create
    interactor :reply_to_conversation, params[:conversation_id], current_user.id.to_s, params[:content]
    render json: {}
  rescue Pavlov::ValidationError => e
    render text: e.message, :status => 400
  end
end
