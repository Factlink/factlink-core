class ConversationsController < ApplicationController
  def show
    @conversation = ConversationGetQuery.execute(params[:id])
    @messages     = MessagesForConversationQuery.execute(@conversation) if @conversation

    respond_to do |format|
      format.html { render_backbone_page }
      format.json do 
        if @conversation and @messages.length > 0
          render 'conversations/show'
        else
          render json: [], status: :not_found
        end
      end
    end
  end
end
