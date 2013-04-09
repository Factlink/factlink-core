require 'acceptance_helper'

feature "channels", type: :request do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::AddToChannelModalHelper

  scenario "I navigate to somebody else's channel and follow it" do
    @user = create :active_user
    other_user = create :active_user

    other_users_channel =
      backend_create_viewable_channel_for other_user, title: 'Henk'
    my_channel =
      backend_create_viewable_channel_for @user, title: 'Henk'

    sign_in_user @user

    go_to_channel_page_of other_users_channel
    assert_on_channel_page other_users_channel.title

    within_channel_header do
      find('button', text: 'follow').click
    end

    go_to_channel_page_of my_channel

    find('#contained-channels a', text: other_users_channel.created_by.user.username)
  end
end
