require 'acceptance_helper'

describe "searching", type: :feature do
  include Acceptance::FactHelper

  before :each do
    @user = sign_in_user create :user, :confirmed
  end

  it "cannot find a something that does not exist" do
    visit root_path

    search_text = "searching for nothing and results for free"
    fill_in "spec-search", with: search_text
    find('#spec-search').native.send_key(:Enter)
    page.should have_content("Sorry, your search didn't return any results.")
  end

  it "finds an annotation" do
    fact_data = create :fact_data

    visit root_path
    fill_in "spec-search", with: fact_data.displaystring
    find('#spec-search').native.send_key(:Enter)

    page.should have_content(fact_data.displaystring)
  end
end
