require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper
  include Acceptance::ChannelHelper

  before do
    @user = sign_in_user create :full_user
    @user2 = create :full_user
  end

  it 'it renders 2 Factlinks' do
    # user create a factlink
    factlink = backend_create_fact

    # user2 interact with user's factlink
    factlink.add_opiniated :believes, @user2.graph_user

    # user2 follow user
    Pavlov.interactor(:'users/follow_user', user_name: @user2.username, user_to_follow_user_name: @user.username, pavlov_options: {current_user: @user2})

    # user2 post to topic
    other_channel = backend_create_channel_of_user @user2
    backend_add_fact_to_channel factlink, other_channel

    visit feed_path(@user.username)

    assume_unchanged_screenshot 'feed'
  end
end
