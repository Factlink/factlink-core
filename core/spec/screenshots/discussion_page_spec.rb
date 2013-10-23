require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper

  it "the layout of the discussion page is correct" do
    @user = sign_in_user create :full_user
    factlink = create_discussion

    go_to_discussion_page_of factlink

    # TODO fix hardcoded values in next line, we're now
    #      implicitly depending on factorygirl behaviour
    find('.evidence-votable', text: 'Fact 2', visible: false).find('a', text:'1 comment')

    page.should have_content factlink.data.displaystring

    assume_unchanged_screenshot "discussion_page"
  end
end
