require 'acceptance_helper'

feature "follow_users_in_tour", type: :feature do
  include PavlovSupport
  include Acceptance::ProfileHelper

  before do
    @user = create :user, :set_up

    @user1 = create :full_user
    @user2 = create :full_user
    Pavlov.command(:'users/add_handpicked_user', user_id: @user1.id.to_s)
    Pavlov.command(:'users/add_handpicked_user', user_id: @user2.id.to_s)

    as(@user1) do |pavlov|
      @user1_channel1 = pavlov.command(:'channels/create', title: 'toy')
      @user1_channel2 = pavlov.command(:'channels/create', title: 'story')

      factlink = create :fact, created_by: @user1.graph_user
      pavlov.interactor(:'channels/add_fact', fact: factlink, channel: @user1_channel1)
      pavlov.interactor(:'channels/add_fact', fact: factlink, channel: @user1_channel2)
    end
    as(@user2) do |pavlov|
      @user2_channel1 = pavlov.command(:'channels/create', title: 'war')
      @user2_channel2 = pavlov.command(:'channels/create', title: 'games')

      factlink = create :fact, created_by: @user2.graph_user
      pavlov.interactor(:'channels/add_fact', fact: factlink, channel: @user2_channel1)
      pavlov.interactor(:'channels/add_fact', fact: factlink, channel: @user2_channel2)
    end
  end

  scenario "The handpicked users should show up" do
    sign_in_user @user
    visit interests_path

    page.should have_content("#{@user1.full_name}")
    page.should have_content("#{@user2.full_name}")

    page.should have_content(@user1_channel1.title)
    page.should have_content(@user1_channel2.title)
    page.should have_content(@user2_channel1.title)
    page.should have_content(@user2_channel2.title)
  end

  scenario "Text should switch to 'Finish tour' when successfully following someone" do
    sign_in_user @user
    visit interests_path

    page.should have_content('Skip this step')

    page.should have_content('Follow user')
    first(:button, 'Follow user').click

    page.should have_content('Following')
    page.should have_content('Finish tour')
  end

  scenario "The user should be able to follow users from the tour" do
    sign_in_user @user
    visit interests_path

    page.should have_content('Follow user')
    first(:button, 'Follow user').click

    go_to_profile_page_of @user
    check_follower_following_count 1, 0
  end

  scenario "When following a user, we also follow her topics" do
    sign_in_user @user
    visit interests_path

    page.should have_content('Follow user')
    first(:button, 'Follow user').click
    first(:button, 'Follow user').click

    click_on 'Finish tour'
  end

  scenario "The user should be able to unfollow users from the tour" do
    sign_in_user @user

    visit interests_path

    page.should have_content('Follow user')
    first(:button, 'Follow user').click

    eventually_succeeds 10 do
      following = Pavlov.interactor(:'users/following', user_name: @user.username, pavlov_options: { current_user: @user})
      following.length.should eq 1
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
