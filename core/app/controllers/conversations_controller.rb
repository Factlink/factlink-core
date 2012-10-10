class ConversationsController < ApplicationController
  def show
    @conversation = ConversationGetQuery.execute(params[:id])
    @messages =   MessagesForConversation.execute(@conversation)

    respond_to do |format|
      format.json { render 'conversations/show'  }
      format.html { render_backbone_page }
    end

  end
end