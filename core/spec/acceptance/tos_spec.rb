require 'acceptance_helper'

describe "Check the ToS", type: :request do

  before do
    @user = make_non_tos_user_and_login
  end

  it "should contain the ToS" do
    page.should have_selector("#tos")
  end

  it "should contain the form elements" do
    page.should have_selector("input#user_tos_first_name")
    page.should have_selector("input#user_tos_last_name")

    page.should have_selector("input#user_email")
    page.should have_selector("input#user_agrees_tos")

    page.should have_css("input#user_email[readonly]")
  end

  it "should show errors when not agreeing the ToS nor filling in name" do
    disable_html5_validations(page)

    click_button "Next"

    page.should have_selector("div.alert")
    page.should have_content("You have to accept the Terms of Service to continue.")
    page.should have_content("Please fill in your first name to accept the Terms of Service.")
    page.should have_content("Please fill in your last name to accept the Terms of Service.")
  end

  describe "when agreeing the ToS" do
    before do
      fill_in "user_tos_first_name", with: "Sko"
      fill_in "user_tos_last_name", with: "Brenden"
      check "user_agrees_tos"

      click_button "Next"

      page.should have_content "You're almost set!"
      click_link "Skip this step"
    end

    it "should redirect to the Interactive Tour" do
      page.should have_content("Climate change")
    end
  end
end
