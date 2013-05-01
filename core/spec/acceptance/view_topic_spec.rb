require 'acceptance_helper'

feature "viewing a topic", type: :request do
  include Acceptance::TopicHelper
  include Acceptance::ChannelHelper
  include Acceptance::ProfileHelper
  include Acceptance::AddToChannelModalHelper

  scenario "When I favourite a topic I should be able to navigate to it in my sidebar" do
    @user = create :active_user
    other_user = create :active_user

    other_users_channel =
      backend_create_viewable_channel_for other_user, title: 'Henk'

    topic = other_users_channel.topic

    sign_in_user @user

    go_to_topic_page_of topic

    within_topic_header do
      find('button', text: 'Favorite').click
    end

    go_to_profile_page_of @user
    click_topic_in_sidebar 'Henk'
    assert_on_topic_page topic
  end
end
