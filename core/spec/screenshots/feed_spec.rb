require 'acceptance_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  before do
    @user = sign_in_user create :full_user
    @user2 = create :full_user
  end

  let(:factlink) { create :fact }

  it 'it renders 2 Factlinks' do

    go_to_discussion_page_of factlink

    comment = "The tomcat hopped on the bus after Berlioz' death"
    add_comment comment

    # user2 follow user
    Pavlov.interactor(:'users/follow_user', username: @user.username, pavlov_options: {current_user: @user2})
    switch_to_user(@user_2)
    visit feed_path

    assume_unchanged_screenshot 'feed'
  end
end
