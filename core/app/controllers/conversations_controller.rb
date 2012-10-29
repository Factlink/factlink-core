class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def pavlov_options
    {current_user: current_user}
  end

  def index
    backbone_responder do
      @conversations = query :conversations_with_users_message, current_user.id.to_s
      raise_404 if not @conversations

      render 'conversations/index'
    end
  end

  def show
    backbone_responder do
      @conversation = query :conversation_with_recipients_and_messages, params[:id]
      raise_404 if not @conversation

      render 'conversations/show'
    end
  end

  def create
    interactor :create_conversation_with_message, params[:fact_id], params[:recipients], current_user.id.to_s, params[:content]
    render json: {}
  end
end
