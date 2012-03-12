require 'spec_helper'
require 'integration_helper'

describe "When visiting the home page" do

  before do
    visit "/"
  end

  context "as a logged out user" do
    it "should be able to view the About page" do
      click_link "About"

      within(:css, "h1") do
        page.should have_content("About Factlink")
      end
    end

    it "should be able to view the Jobs page" do
      click_link "Jobs"
      within(:css, "h1") do
        page.should have_content("Jobs")
      end
    end
  end

end