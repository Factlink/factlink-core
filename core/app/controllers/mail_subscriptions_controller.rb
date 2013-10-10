class MailSubscriptionsController < ApplicationController
  layout "responsive_notifications"

  def update
    if @user = User.where(notification_settings_edit_token: params[:token]).first
      if @user.unsubscribe(params[:type])
        render 'success'
      else
        render 'error'
      end
    else
      render 'expired'
    end
  end

end
