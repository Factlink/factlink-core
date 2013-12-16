require 'acceptance_helper'

describe "creating a Factlink", type: :feature do
  include Acceptance::ProfileHelper
  include Acceptance::AddToChannelModalHelper
  include Acceptance::NavigationHelper
  include Acceptance::FactHelper

  before :each do
    @user = sign_in_user create :full_user, :confirmed
  end

  it "should add a factlink" do
    fact_name = "baronnenbillen"

    visit new_fact_path(displaystring: fact_name)

    eventually_succeeds do
      fail StandardError, "Fact not created" unless Fact.all.to_a.last
    end

    go_to_profile_page_of @user

    page.should have_content "Feed"
    page.should have_content fact_name
  end

  it "should be able to delete a factlink" do
    fact_name = "raar"

    visit new_fact_path(displaystring: fact_name)

    eventually_succeeds do
      fail StandardError, "Fact not created" unless Fact.all.to_a.last
    end

    go_to_discussion_page_of Fact.all.to_a.last

    page.should have_content fact_name

    find('.delete-button-first').click
    find('.delete-button-second').click

    go_to_profile_page_of @user
    page.should_not have_content fact_name
  end
end
