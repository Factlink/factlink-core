require 'acceptance_helper'

feature 'the profile page', type: :feature do
  include Acceptance::ProfileHelper
  include Acceptance::FactHelper
  include PavlovSupport

  scenario 'follow a user and unfollow a user' do
    following_user = sign_in_user create :user, :confirmed
    followed_user = create :user, :confirmed

    go_to_profile_page_of followed_user

    # initial state check of other user profile
    check_follower_following_count 0, 0

    # follow other user
    click_button 'Follow'

    # check if info is updated directly
    check_follower_following_count 0, 1

    # visit own profile
    go_to_profile_page_of following_user

    # check if own profile is updated
    check_follower_following_count 1, 0

    # goto followed user profile with a full refresh
    go_to_profile_page_of followed_user

    # check if info is persisted
    check_follower_following_count 0, 1

    # unfollow page
    click_button 'Following'

    # check if info is updated directly
    check_follower_following_count 0, 0

    # refresh page
    go_to_profile_page_of followed_user

    # check if info is persisted
    check_follower_following_count 0, 0

    # visit own profile
    go_to_profile_page_of following_user

    # check if own profile is updated
    check_follower_following_count 0, 0
  end

  scenario 'follow a user and facts created by that user show up in your stream' do
    following_user = sign_in_user create :user, :confirmed
    followed_user = create :user, :confirmed

    go_to_profile_page_of followed_user

    # initial state check of other user profile
    check_follower_following_count 0, 0

    # follow other user
    click_button 'Follow'

    # check if info is updated directly
    check_follower_following_count 0, 1

    displaystring = 'this is a displaystring for fact'

    as(followed_user) do |backend|
      dead_fact = backend.interactor(:'facts/create', displaystring: displaystring, site_url: 'http://example.org', site_title: 'title')
      backend.interactor(:'comments/create', fact_id: dead_fact.id, type: 'believes', content: "so true")
    end

    visit feed_path

    page.should have_content displaystring
  end
end
