class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    backbone_responder do
      @conversations = query(:'conversations_with_users_message', user_id: current_user.id.to_s)
      raise_404 unless @conversations

      render 'conversations/index'
    end
  end

  def show
    backbone_responder do
      @conversation = query(:'conversation_with_recipients_and_messages', id: params[:id])
      raise_404 unless @conversation

      render 'conversations/show'
    end
  end

  def create
    get_interactor(:'create_conversation_with_message',
                   fact_id: params[:fact_id],
                   recipient_usernames: params[:recipients],
                   sender_id: current_user.id.to_s,
                   content: params[:content]) do |interaction|
      if interaction.valid?
        interaction.call
        render json: {}
      else
        error_message = interaction.errors.full_messages.first
        render text: error_message, :status => 400
      end
    end
  end
end
