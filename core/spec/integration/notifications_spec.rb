require 'integration_helper'
# require 'launchy'

feature "notifications", type: :request do
  include Acceptance::ChannelHelper

  scenario "can be clicked and will navigate to other page" do
    user1 = create :approved_confirmed_user
    user2 = create :approved_confirmed_user

    channel_user1 = create :channel, created_by: user1.graph_user
    channel_user2 = create :channel, created_by: user2.graph_user

    factlink_user1 = create :fact, created_by: user1.graph_user
    factlink_user2 = create :fact, created_by: user2.graph_user

    backend_add_fact_to_channel factlink_user1, channel_user1
    backend_add_fact_to_channel factlink_user2, channel_user2

    channel_user1.add_channel(channel_user2)

    sign_in_user user2

    find('#notifications .unread', text: "1").click

    find('#notifications .dropdown-menu .unread a').click

    find('#channel > header > h1', text: channel_user1.title)
  end
end
