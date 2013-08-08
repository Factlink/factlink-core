require 'acceptance_helper'

describe "Check the ToS", type: :feature do

  before do
    @user = make_non_tos_user_and_login
  end

  it "should contain the ToS" do
    page.should have_selector("#tos")
  end

  it "should contain the form elements" do
    page.should have_selector("input#user_agrees_tos")
  end

  it "should show errors when not agreeing the ToS nor filling in name" do
    disable_html5_validations(page)

    click_button "Next"

    page.should have_selector("div.alert")
    page.should have_content("You have to accept the Terms of Service to continue.")
  end

  describe "when agreeing the ToS" do
    before do
      check "user_agrees_tos"

      click_button "Next"
    end

    it "should redirect to the Interactive Tour" do
      page.should have_content "Select any statement on the right to start creating your Factlink."
    end
  end
end
