class MailSubscriptionsController < ApplicationController
  layout "responsive_notifications"

  before_filter :get_user

  def update
    @type = params[:type]
    @subscribe_action = params[:subscribe_action]

    if @user
      if update_subscription(@subscribe_action, @type, @user)
        render 'success'
      else
        render 'error'
      end
    else
      render 'expired'
    end
  end

  private

  def get_user
    @user = User.where("user_notification.notification_settings_edit_token" => params[:token]).first
  end

  def update_subscription(subscribe_action, type, user)
    case subscribe_action.to_s
    when 'unsubscribe'
      success = user.user_notification.unsubscribe(type)
      SubscriptionsMailer.unsubscribe(user.id, type).deliver
      success
    when 'subscribe'
      user.user_notification.subscribe(type)
    else
      false
    end
  end
end
