require 'acceptance_helper'

feature "follow_users_in_tour", type: :feature do
  include PavlovSupport
  include Acceptance::ProfileHelper
  include Acceptance::TopicHelper

  before do
    @user = create :approved_confirmed_user

    @user1 = create :user
    @user2 = create :user
    Pavlov.command(:'users/add_handpicked_user', user_id: @user1.id.to_s)
    Pavlov.command(:'users/add_handpicked_user', user_id: @user2.id.to_s)

    as(@user1) do |pavlov|
      @user1_channel1 = pavlov.command(:'channels/create', title: 'toy')
      pavlov.command(:'topics/update_user_authority', graph_user_id: @user1.graph_user_id.to_s, topic_slug: @user1_channel1.slug_title, authority: 0)
      @user1_channel2 = pavlov.command(:'channels/create', title: 'story')
      pavlov.command(:'topics/update_user_authority', graph_user_id: @user1.graph_user_id.to_s, topic_slug: @user1_channel2.slug_title, authority: 3)
    end
    as(@user2) do |pavlov|
      @user2_channel1 = pavlov.command(:'channels/create', title: 'war')
      pavlov.command(:'topics/update_user_authority', graph_user_id: @user2.graph_user_id.to_s, topic_slug: @user2_channel1.slug_title, authority: 0)

      @user2_channel2 = pavlov.command(:'channels/create', title: 'games')
      pavlov.command(:'topics/update_user_authority', graph_user_id: @user2.graph_user_id.to_s, topic_slug: @user2_channel2.slug_title, authority: 4568)
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

    eventually_succeeds 10 do
      follower_counts = Pavlov.interactor(:'users/following', user_name: @user.username, skip: 0, take: 0, pavlov_options: { current_user: @user})
      follower_counts[1].should eq 1
      #TODO: this is really a hack to ensure that the subsequent unfollow
      # really does happen after the original follow even on the server.
    end

    first(:button, 'Following').click # Unfollow
    eventually_succeeds 10 do
      sleep 0.05
      go_to_profile_page_of @user
      check_follower_following_count 0, 0
    end
  end
end
