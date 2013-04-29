require 'acceptance_helper'

feature "viewing a topic", type: :request do
  include Acceptance::TopicHelper
  include Acceptance::ChannelHelper
  include Acceptance::ProfileHelper
  include Acceptance::AddToChannelModalHelper

  scenario "When I follow a channel I should be able to navigate to the topic in my sidebar" do
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

    go_to_profile_page_of @user
    click_topic_in_sidebar 'Henk'
    assert_on_topic_page other_users_channel.topic
  end
end
