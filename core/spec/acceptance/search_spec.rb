require 'acceptance_helper'

describe "searching", type: :feature do
  include Acceptance::FactHelper

  before :each do
    @user = sign_in_user create :user, :confirmed
  end

  it "cannot find a something that does not exist" do
    visit root_path

    search_text = "searching for nothing and results for free"
    fill_in "factlink_search", with: search_text
    page.execute_script("$('#factlink_search').parent().submit()")
    page.should have_content("Sorry, your search didn't return any results.")
  end

  it "should find a just created factlink" do
    fact = backend_create_fact

    eventually_succeeds do
      fail StandardError, "Fact not created" unless Fact.all.to_a.last
    end

    # and search for it:
    visit root_path
    fill_in "factlink_search", with: fact.to_s
    page.execute_script("$('#factlink_search').parent().submit()")
    page.should have_content(fact.to_s)
  end
end
