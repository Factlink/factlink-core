require 'integration_helper'

describe "When visiting the home page", type: :request do

  before do
    visit "/"
  end

  context "as a logged out user" do
    it "should be able to view the Home page" do
      click_link "Home"

      within(:css, "h2") do
        page.should have_content("Building a collectively reviewed perspective on the world's information")
      end
    end
   
    it "should be able to view the About page" do
      click_link "About"

      within(:css, "h1") do
        page.should have_content("Building a collective perspective")
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

    it "should be able to view the Blog page" do
      click_link "Blog"
      within(:css, "h2") do
        page.should have_content("Pages")
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
      click_link "Privacy Policy"
      within(:css, "h1") do
        page.should have_content("Privacy Policy")
      end
    end


  end

end