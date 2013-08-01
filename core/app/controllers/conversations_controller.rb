class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    backbone_responder do
      @conversations = old_query :conversations_with_users_message, current_user.id.to_s
      raise_404 unless @conversations

      render 'conversations/index'
    end
  end

  def show
    backbone_responder do
      @conversation = old_query :conversation_with_recipients_and_messages, params[:id]
      raise_404 unless @conversation

      render 'conversations/show'
    end
  end

  def create
    old_interactor :create_conversation_with_message, params[:fact_id], params[:recipients], current_user.id.to_s, params[:content]
    render json: {}
  rescue Pavlov::ValidationError => e
    render text: e.message, :status => 400
  end
end
