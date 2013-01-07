require 'integration_helper'

feature "channels", type: :request do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::AddToChannelModalHelper

  scenario "I navigate to somebody else's channel and follow it" do
    @user = create :active_user
    other_user = create :active_user

    other_users_channel =
      backend_create_viewable_channel_for other_user
    my_channel =
      backend_create_viewable_channel_for @user

    sign_in_user @user

    go_to_channel_page_of other_users_channel
    assert_on_channel_page other_users_channel.title

    within_channel_header do
      find('button', text: 'add').click
    end

    within_modal do
      add_to_channel my_channel.title
      added_channels_should_contain my_channel.title
    end

    go_to_channel_page_of my_channel

    within_channel_header do
      find('a', text: other_users_channel.title)
    end
  end
end
