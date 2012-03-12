require 'spec_helper'
require 'integration_helper'

describe "Channel" do

  before :each do
    @user = int_user
    visit "/"

    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password

    click_button 'Sign in'
  end

  it "should be able to create and delete", js: true do

    channel_title = "Teh hot channel"

    # Creating a new Channel
    click_link "Add new"

    fill_in "channel_title", with: channel_title
    click_button "Save"

    within(:css, "h1") do
      page.should have_content(channel_title)
    end

    # Visiting the edit page
    click_link "edit"

    # Delete the created Channel
    handle_js_confirm(accept=true) do
      click_link "delete"
    end
    save_and_open_page
  end

end