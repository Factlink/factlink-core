class MailSubscriptionsController < ApplicationController
  layout "responsive_notifications"

  def update
    if @user = User.where("user_notification.notification_settings_edit_token" => params[:token]).first
      success = case params[:subscribe_action].to_s
                when 'unsubscribe'
                  @user.user_notification.unsubscribe(params[:type])
                when 'subscribe'
                  @user.user_notification.subscribe(params[:type])
                else false
                end
      if success
        render 'success'
      else
        render 'error'
      end
    else
      render 'expired'
    end
  end

end
