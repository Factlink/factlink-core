class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def show
    authorize! :access, Ability::FactlinkWebapp

    backbone_responder
  end

  def create
    interactor(:'reply_to_conversation',
               conversation_id: params[:conversation_id],
               sender_id: current_user.id.to_s,
               content: params[:content]) do |interaction|
      if interaction.valid?
        interaction.call
        render json: {}
      else
        error_message = interaction.errors.full_messages.first
        render text: error_message, status: 400
      end
    end
  end
end
