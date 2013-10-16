require 'acceptance_helper'

feature "notifications", type: :feature do
  include Acceptance::ChannelHelper
  include Acceptance::NotificationHelper
  include Acceptance::NavigationHelper
  include Acceptance::AddToChannelModalHelper
  include PavlovSupport

  scenario %q{When another user follows my channel,
            I get a notification, and can click on it,
            to go to the following channel} do
    current_user = create :full_user, :confirmed, :seeing_channels
    other_user = create :full_user, :confirmed, :seeing_channels

    other_users_channel =
      backend_create_viewable_channel_for other_user
    my_channel =
      backend_create_viewable_channel_for current_user

    as(other_user) do |p|
      p.interactor(:'channels/add_subchannel', channel_id: other_users_channel.id, subchannel_id: my_channel.id)
    end

    sign_in_user current_user

    assert_number_of_unread_notifications 1
    open_notifications
    within_first_notification do
      find("a").click
    end
    assert_on_channel_page other_users_channel.title
  end


  scenario %q{When another user follows my channel,
            I get a notification, and directly follow
            back their channel from the notification} do
    current_user = create :full_user, :confirmed, :seeing_channels
    other_user = create :full_user, :confirmed, :seeing_channels

    other_users_channel =
      backend_create_viewable_channel_for other_user
    my_channel =
      backend_create_viewable_channel_for current_user

    as(other_user) do |p|
      p.interactor(:'channels/add_subchannel', channel_id: other_users_channel.id, subchannel_id: my_channel.id)
    end

    sign_in_user current_user

    assert_number_of_unread_notifications 1
    open_notifications

    within_first_notification do
      click_button 'Follow'
    end

    within_first_notification do
      find('button', text: 'Following')
    end

    sleep 2 # give ajax requests some time to finish

    visit page.current_url

    open_notifications
    within_first_notification do
      find('button', text: 'Following')
    end
  end
end
