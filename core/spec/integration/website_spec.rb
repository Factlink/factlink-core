require 'integration_helper'

describe "When visiting the Factlink website", type: :request do

  before do
    visit "/"
  end

  context "when not logged in" do
    it "the Home page" do
      within(:css, "h1") do
        page.should have_content("A layer over the web to add and view credibility")
      end
    end

    it "should be able to view the About page" do
      click_link "About"

      within(:css, "h1") do
        page.should have_content("Because the web needs what you know")
      end
    end

    it "should be able to view the Team page" do
      click_link "Team"
      within(:css, "h1") do
        page.should have_content("The people behind Factlink")
      end
    end

    it "should be able to view the Jobs page" do
      click_link "Jobs"
      within(:css, "h1") do
        page.should have_content("Jobs")
      end
    end

    it "should be able to view the Contact page" do
      click_link "Contact"
      within(:css, "h1") do
        page.should have_content("Contact us")
      end
    end

    it "should be able to view the TOS page" do
      click_link "Terms of Service"
      within(:css, "h1") do
        page.should have_content("Terms of Service")
      end
    end

    it "should be able to view the Privacy Policy page" do
      click_link "Privacy"
      within(:css, "h1") do
        page.should have_content("Privacy Policy")
      end
    end

    it "should be able to view the Privacy Policy page" do
      click_link "Privacy"
      within(:css, "h1") do
        page.should have_content("Privacy Policy")
      end
    end
  end
end
