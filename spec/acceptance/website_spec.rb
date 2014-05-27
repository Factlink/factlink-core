require 'acceptance_helper'

describe "Logged-out visitors", type: :feature do
  before do
    visit "/"
  end

  context "when not logged in" do
    it "should be able to view the About page", slow: true do
      click_link "About"

      within(:css, "h1") do
        page.should have_content("About " + I18n.t(:app_name))
      end
    end

    it "should be able to view the TOS page", slow: true do
      click_link "Terms of Service"
      within(:css, "h1") do
        page.should have_content("Terms of Service")
      end
    end

    it "should be able to view the Privacy Policy page", slow: true do
      click_link "Privacy"
      within(:css, "h1") do
        page.should have_content("Privacy Policy")
      end
    end
  end
end
