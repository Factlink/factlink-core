require 'integration_helper'

describe "creating a Factlink", type: :request do
  def created_channel_path(user)
    channel_path(user.username, user.graph_user.created_facts_channel.id)
  end

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  it "should add a factlink" do
    fact_name = "baronnenbillen"

    visit new_fact_path
    fill_in "fact", with: fact_name
    click_button "submit"

    visit created_channel_path(@user)

    page.should have_content "Stream"
    page.should have_content fact_name
  end

  it "should be able to delete a factlink" do
    fact_name = "raar"

    # create fact:
    visit new_fact_path
    fill_in "fact", with: fact_name
    click_button "submit"

    visit created_channel_path(@user)

    page.should have_content fact_name

    # and delete it:
    page.evaluate_script('window.confirm = function() { return true; }')

    page.find(:css, ".top-right-arrow").click

    page.find(:css, "li.delete").click

    page.should_not have_content fact_name
  end
end
