require 'acceptance_helper'

describe "searching", type: :feature do

  def create_channel(user)
    channel = create(:channel, created_by: user.graph_user)
    channel
  end

  before :each do
    @user = sign_in_user create :active_user
  end

  it "cannot find a something that does not exist" do
    search_text = "searching for nothing and results for free"
    fill_in "factlink_search", with: search_text
    page.execute_script("$('#factlink_search').parent().submit()")
    page.should have_content("Sorry, your search didn't return any results.")
  end

  it "should find a just created factlink" do
    # create factlink:
    fact_title = "fact to be found"
    visit new_fact_path fact: fact_title
    click_button "Post to Factlink"

    # and search for it:
    visit root_path
    fill_in "factlink_search", with: fact_title
    page.execute_script("$('#factlink_search').parent().submit()")
    page.should have_content(fact_title)
  end
end
