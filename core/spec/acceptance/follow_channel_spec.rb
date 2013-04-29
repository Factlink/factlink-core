require 'acceptance_helper'

feature "channels", type: :request do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::AddToChannelModalHelper
  include Acceptance::TopicHelper

  scenario "I navigate to somebody else's channel and follow it, and then go to my channel directly" do
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
      find('button', text: 'Follow').click
    end

    go_to_channel_page_of my_channel

    find('#contained-channels a', text: other_users_channel.created_by.user.username)
  end

  scenario "I navigate to somebody else's channel and follow it, and then go to my channel via a topic" do
    @user = create :active_user
    other_user = create :active_user

    other_users_channel =
      backend_create_viewable_channel_for other_user, title: 'Henk'

    sign_in_user @user

    go_to_channel_page_of other_users_channel
    assert_on_channel_page other_users_channel.title

    within_channel_header do
      find('button', text: 'Follow').click
    end

    go_to_topic_page_of other_users_channel.topic
    switch_to_factlinks_from_people_i_follow

    find('#contained-channels a', text: other_users_channel.created_by.user.username)
  end
end
