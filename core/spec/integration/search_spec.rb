require 'integration_helper'
  
def create_channel(user)
  channel = FactoryGirl.create(:channel, created_by: user.graph_user)
  channel
end
    
describe "searching", type: :request do
  
  before :each do
    @user = make_user_and_login
  end

  it "cannot find a something that does not exist", js:true do
    search_text = "searching for nothing and results for free"
    fill_in "factlink_search", with: search_text
    page.execute_script("$('#factlink_search').parent().submit()")
    page.should have_content("Sorry, your search didn't return any results.")
  end

  it "should find a just created factlink", js:true do
    # create factlink:
    visit new_fact_path
    fact_title = "fact to be found"
    fill_in "fact", with: fact_title
    click_button "submit"

    # and search for it:
    visit root_path
    fill_in "factlink_search", with: fact_title
    page.execute_script("$('#factlink_search').parent().submit()")
    page.should have_content(fact_title)
  end
end
