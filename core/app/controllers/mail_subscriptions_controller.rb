class MailSubscriptionsController < ApplicationController

  def update
    if user = User.where(notification_settings_edit_token: params[:token]).first
      if user.unsubscribe(params[:type])
        render text: 'Successfully unsubscribed.'
      else
        render text: 'Something went wrong with unsubscribing, maybe you already were unsubscribed?'
      end
    else
      render text: 'Unrecognized token, maybe your token expired?'
    end
  end

end
