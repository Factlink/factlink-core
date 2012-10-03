require 'integration_helper'

def create_channel(user)
  FactoryGirl.create(:channel, created_by: user.graph_user)
end

describe "channels", type: :request do

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  it "can be created" do
    channel_title = "Teh hot channel"
    click_link "Add new"
    fill_in "channel_title", with: channel_title
    click_button "Create"

    within(:css, "h1") do
      page.should have_content(channel_title)
    end

    # Visiting the edit page and editing the page
    click_link "edit"
    channel_title_modified = "this is the corrected one"
    fill_in "channel_title", with: channel_title_modified
    click_button "Apply"

    within(:css, "h1") do
      page.should have_content(channel_title_modified)
    end

    click_link "edit"
    handle_js_confirm(accept=true) do
      click_link "Delete"
    end

    within(:css, "h1") do
      page.should_not have_content(channel_title_modified)
    end
  end

  it "can be visited" do
    @channel = create_channel(@user)

    visit channel_path(@user, @channel)

    page.should have_content(@channel.title)
  end
end
