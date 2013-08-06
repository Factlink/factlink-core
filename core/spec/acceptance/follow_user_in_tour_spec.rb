require 'acceptance_helper'

feature "follow_users_in_tour", type: :feature do
  include PavlovSupport
  include Acceptance::ProfileHelper
  include Acceptance::TopicHelper

  before do
    @user = create :approved_confirmed_user

    @user1 = create :user
    @user2 = create :user
    Pavlov.old_command :"users/add_handpicked_user", @user1.id.to_s
    Pavlov.old_command :"users/add_handpicked_user", @user2.id.to_s

    as(@user1) do |pavlov|
      @user1_channel1 = pavlov.old_command :'channels/create', 'toy'
      pavlov.old_command :'topics/update_user_authority',
        @user1.graph_user_id.to_s, @user1_channel1.slug_title, 0
      @user1_channel2 = pavlov.old_command :'channels/create', 'story'
      pavlov.old_command :'topics/update_user_authority',
        @user1.graph_user_id.to_s, @user1_channel2.slug_title, 3
    end
    as(@user2) do |pavlov|
      @user2_channel1 = pavlov.old_command :'channels/create', 'war'
      pavlov.old_command :'topics/update_user_authority',
        @user2.graph_user_id.to_s, @user2_channel1.slug_title, 0

      @user2_channel2 = pavlov.old_command :'channels/create', 'games'
      pavlov.old_command :'topics/update_user_authority',
        @user2.graph_user_id.to_s, @user2_channel2.slug_title, 4568
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

    # Click on one user
    first(:button, 'Follow user').click

    page.should have_content('Following')
    page.should have_content('Finish tour')
  end

  scenario "The user should be able to follow users from the tour" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    first(:button, 'Follow user').click

    go_to_profile_page_of @user
    check_follower_following_count 1, 0
  end

  scenario "When following a user, we also follow her topics" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    first(:button, 'Follow user').click
    first(:button, 'Follow user').click

    click_on 'Finish tour'
    click_topic_in_sidebar 'toy'
  end

  scenario "The user should be able to unfollow users from the tour" do
    sign_in_user @user
    visit interests_path
    click_on 'Got it!'

    first(:button, 'Follow user').click
    first(:button, 'Following').click # Unfollow

    eventually_succeeds do
      go_to_profile_page_of @user
      check_follower_following_count 0, 0
    end
  end
end
