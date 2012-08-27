require 'integration_helper'
  
def create_factlink(user)
  FactoryGirl.create(:fact, created_by: user.graph_user)
end
  
describe "factlinks" do
  
  before :each do
    @user = make_user_and_login
  end

  pending "should be able to search for evidence", js:true do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    click_on "Supporting"

    fill_in 'supporting_search', :with => search_string

    sleep 1
    until page.evaluate_script('$.isReady && $.active===0') do
      sleep 1
    end

    page.should have_selector('.supporting li.add')

    page.execute_script('$(".supporting li.add").trigger("click")')

    sleep 10

    page.should have_selector('li.fact-relation')
    within(:css, 'li.fact-relation') do
      page.should have_content search_string
    end
  end
end
