require 'acceptance_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest
  include Acceptance::FeedHelper

  let(:user) { create :user }

  it 'it renders 2 Factlinks' do
    create_default_activities_for user

    sign_in_user(user)

    visit feed_path
    find('label[for=FeedChoice_Personal]').click
    find('.feed-activity:first-child')
    assume_unchanged_screenshot 'feed'
  end
end
