require 'integration_helper'

def create_factlink(user)
  FactoryGirl.create(:fact, created_by: user.graph_user)
end

def wait_until_scope_exists(scope, &block)
  wait_until { page.has_css?(scope) }
  within scope, &block
rescue Capybara::TimeoutError
  flunk "Expected '#{scope}' to be present."
end

describe "factlinks", type: :request do
  include FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  it "should be able to add evidence", js:true do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    click_on "Supporting"

    wait_until_scope_exists '.add-evidence-container' do
      fill_in 'supporting_search', :with => search_string
      wait_for_ajax
    end
    
    page.should have_selector('.supporting li.add')
  
    page.execute_script('$(".supporting li.add").trigger("click")')

    wait_for_ajax

    page.should have_selector('li.fact-relation')
    within(:css, 'li.fact-relation') do
      page.should have_content search_string
    end
  end
end
