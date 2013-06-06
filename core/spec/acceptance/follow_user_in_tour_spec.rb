require 'acceptance_helper'

feature "follow_users_in_tour", type: :request do
  include PavlovSupport
  include Acceptance::ProfileHelper
  include Acceptance::TopicHelper

  before do
    @user = create :approved_confirmed_user

    create :user # HACK create user with id 2 (so the next user has an id that is not hardcoded in TopWithAuthorityForGraphUserId Query)
    @user1 = create :user
    create :user # HACK create user with id 4 (so the next user has an id that is not hardcoded in TopWithAuthorityForGraphUserId Query)
    @user2 = create :user
    Pavlov.command :"users/add_handpicked_user", @user1.id.to_s
    Pavlov.command :"users/add_handpicked_user", @user2.id.to_s

    as(@user1) do |pavlov|
      @user1_channel1 = pavlov.command :'channels/create', 'toy'
      @user1_channel2 = pavlov.command :'channels/create', 'story'
      Authority.from(@user1_channel2.topic, for: @user1.graph_user) << 3
    end
    as(@user2) do |pavlov|
      @user2_channel1 = pavlov.command :'channels/create', 'war'
      @user2_channel2 = pavlov.command :'channels/create', 'games'
      Authority.from(@user2_channel2.topic, for: @user2.graph_user) << 4568
    end
  end

  scenario "The handpicked users should show up" do
    sign_in_user @user
    visit interests_path

    page.should have_content('What is this?')
    click_on 'Got it!'
    page.should_not have_content('What is this?')

    page.should have_content("#{@user1.first_name} #{@user1.last_name}")
    page.should have_content("#{@user2.first_name} #{@user2.last_name}")

    page.should have_content(@user1_channel1.title)
    page.should have_content(@user1_channel2.title)
    page.should have_content(@user2_channel1.title)
    page.should have_content(@user2_channel2.title)
  end

  scenario "Text should switch to 'Finish tour' when successfully following someone" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    page.should have_content('Skip this step')

    click_on 'Follow user' # Click one of both users
    wait_for_ajax
    page.should have_content('Following')
    page.should have_content('Finish tour')
  end

  scenario "The user should be able to follow users from the tour" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    click_on 'Follow user'
    wait_for_ajax

    go_to_profile_page_of @user
    check_follower_following_count 1, 0
  end

  scenario "When following a user, we also follow her topics" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    click_on 'Follow user'
    wait_for_ajax
    click_on 'Follow user'
    wait_for_ajax

    click_on 'Finish tour'
    click_topic_in_sidebar 'toy'
  end

  scenario "The user should be able to unfollow users from the tour" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    click_on 'Follow user'
    wait_for_ajax

    click_on 'Following' # Unfollow
    wait_for_ajax

    go_to_profile_page_of @user
    check_follower_following_count 0, 0
  end
end
