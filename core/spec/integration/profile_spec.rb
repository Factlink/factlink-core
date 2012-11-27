require 'integration_helper'

feature "the profile page", type: :request do
  include Acceptance
  include Acceptance::ProfileHelper

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
    @channel = create :channel, created_by: @user.graph_user
  end

  scenario "the users top channels should render" do
    go_to_profile_page_of @user

    wait_until_scope_exists 'div.top-channels' do
      page.should have_content(@channel.title)
    end
  end
end
