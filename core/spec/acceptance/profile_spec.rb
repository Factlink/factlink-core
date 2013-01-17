require 'acceptance_helper'

feature "the profile page", type: :request do
  include Acceptance
  include Acceptance::ProfileHelper

  background do
    @user = sign_in_user FactoryGirl.create :active_user
    @channel = create :channel, created_by: @user.graph_user
  end

  scenario "the users top channels should render" do
    go_to_profile_page_of @user

    find('.top-channels li', text: @channel.title)
  end
end
