require 'acceptance_helper'

describe "factlink", type: :feature do
  include ScreenshotTest
  include FeedHelper

  let(:user) { create :user }

  unless FactlinkUI.Kennisland?
  it 'it renders 2 Factlinks' do
    create_default_activities_for user

    sign_in_user(user)

    visit feed_path
    find('label', text:'Personal').click
    find('.spec-feed-activity+.spec-loading-indicator-done')
    assume_unchanged_screenshot 'feed'
  end
end
end
