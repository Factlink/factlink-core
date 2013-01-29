require 'screenshot_helper'

describe "factlink", type: :request do
  include FactHelper

  def create_factlink(user)
    FactoryGirl.create(:fact, created_by: user.graph_user)
  end

  before :each do
    @user = sign_in_user FactoryGirl.create :active_user
  end

  it "the layout of the discussion page is correct" do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "discussion_page"
  end
end
