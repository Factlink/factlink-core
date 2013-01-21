require 'screenshot_helper'

describe "Compare screens", type: :request do
  pending "should render the frontpage as expected" do
    visit "/?show_sign_in=true"
    assume_unchanged_screenshot "homepage"
  end
end
