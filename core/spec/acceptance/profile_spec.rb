require 'acceptance_helper'

feature 'the profile page', type: :feature do
  include Acceptance::ProfileHelper
  include Acceptance::FactHelper
  include PavlovSupport

  scenario "the users top channels should render" do
    user = sign_in_user create :active_user
    channel = create :channel, created_by: user.graph_user

    go_to_profile_page_of user

    find('.top-channels *', text: channel.title)
  end

  scenario 'follow a user and unfollow a user' do
    following_user = sign_in_user create :active_user
    followed_user = create :active_user

    visit user_path(followed_user)

    # initial state check of other user profile
    check_follower_following_count 0, 0

    # follow other user
    click_button 'Follow'

    # check if info is updated directly
    check_follower_following_count 0, 1

    # visit own profile
    visit user_path(following_user)

    # check if own profile is updated
    check_follower_following_count 1, 0

    # goto followed user profile with a full refresh
    visit user_path(followed_user)

    # check if info is persisted
    check_follower_following_count 0, 1

    # unfollow page
    click_button 'Following'

    # check if info is updated directly
    check_follower_following_count 0, 0

    # refresh page
    visit user_path(followed_user)

    # check if info is persisted
    check_follower_following_count 0, 0

    # visit own profile
    visit user_path(following_user)

    # check if own profile is updated
    check_follower_following_count 0, 0
  end

  scenario 'follow a user and facts created by that user show up in your stream' do
    following_user = sign_in_user create :active_user
    followed_user = create :active_user

    channel = create :channel, created_by: followed_user.graph_user

    visit user_path(followed_user)

    # initial state check of other user profile
    check_follower_following_count 0, 0

    # follow other user
    click_button 'Follow'

    # check if info is updated directly
    check_follower_following_count 0, 1

    displaystring = 'this is a displaystring for fact'

    fact = nil
    as(followed_user) do |backend|
      fact = backend.old_interactor :'facts/create', displaystring,'','title', {}
      backend.old_interactor :'channels/add_fact', fact, channel
    end

    visit channel_activities_path(following_user.username,following_user.graph_user.stream_id)

    page.should have_content displaystring
  end
end
