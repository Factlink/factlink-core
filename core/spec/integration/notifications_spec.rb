require 'integration_helper'

feature "notifications", type: :request do
  include Acceptance::ChannelHelper
  include Acceptance::NotificationHelper

  scenario %q{When another user follows my channel,
            I get a notification, and can click on it,
            to go to the following channel} do
    current_user = create :approved_confirmed_user
    other_user = create :approved_confirmed_user

    other_users_channel =
      backend_create_viewable_channel_for other_user
    my_channel =
      backend_create_viewable_channel_for current_user

    backend_channel_add_subchannel other_users_channel, my_channel

    sign_in_user current_user

    assert_number_of_unread_notifications 1
    open_notifications
    click_on_nth_notification 1
    assert_on_channel_page @channel_other_user.title
  end
end
