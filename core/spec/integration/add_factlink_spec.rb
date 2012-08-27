require 'integration_helper'

def created_channel_path(user)
  channel_path(user.username, user.graph_user.created_facts_channel.id)
end

describe "creating a Factlink" do
  before :each do
    @user = make_user_and_login
  end

  it "should add a factlink", js:true do
    fact_name = "baronnenbillen"

    visit new_fact_path
    fill_in "fact", with: fact_name
    click_button "submit"

    visit created_channel_path(@user)

    page.should have_content "My Stream"
    page.should have_content fact_name
  end

  it "should be able to delete a factlink", js:true do
    fact_name = "raar"

    # create fact:
    visit new_fact_path
    fill_in "fact", with: fact_name
    click_button "submit"

    visit created_channel_path(@user)

    page.should have_content fact_name

    # and delete it:
    page.evaluate_script('window.confirm = function() { return true; }')
    page.execute_script("$($('article.fact')[0]).parent().find('li.delete').click()")

    page.should_not have_content fact_name
  end
end