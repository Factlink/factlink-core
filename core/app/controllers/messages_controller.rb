class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def pavlov_options
    {current_user: current_user}
  end

  def create
    interactor :reply_to_conversation, params[:conversation_id], params[:sender_id], params[:content]
    render json: {}
  end
end
