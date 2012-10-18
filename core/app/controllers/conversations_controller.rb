class ConversationsController < ApplicationController
  def show
    respond_to do |format|
      format.html { render_backbone_page }
      format.json do
        @conversation = Queries::ConversationGet.execute(params[:id], current_user: current_user)
        if @conversation
          @messages = Queries::MessagesForConversation.execute(@conversation, current_user: current_user)
        end
        if @conversation and @messages.length > 0
          render 'conversations/show'
        else
          render json: [], status: :not_found
        end
      end
    end
  end

  def create
    CreateConversationWithMessageInteractor.perform(params[:recipients], params[:sender], params[:content], current_user: current_user)
    render json: {}
  end
end
