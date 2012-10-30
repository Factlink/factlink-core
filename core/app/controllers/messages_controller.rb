class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    interactor :reply_to_conversation, params[:conversation_id], current_user.id.to_s, params[:content]
    render json: {}
  end
end
