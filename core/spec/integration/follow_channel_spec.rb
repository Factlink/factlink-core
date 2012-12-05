require 'integration_helper'

describe "channels", type: :request do
  it "can follow somebody else channel" do
    user = FactoryGirl.create :approved_confirmed_user
    channel_to_follow = FactoryGirl.create(:channel, created_by: user.graph_user)

    user2 = sign_in_user FactoryGirl.create :approved_confirmed_user
    own_channel = FactoryGirl.create(:channel, created_by: user2.graph_user)

    visit channel_path(user, channel_to_follow)

    page.should have_content(channel_to_follow.title)

    within(:css, '.add-to-channel-region') do
      find('#add-to-channel').click

      page.find(:css,'input').set(own_channel.title)

      page.find('li', text: own_channel.title).click

      within(:css, '.auto-complete-results-container') do
        find("li a", text: "#{own_channel.title}")
      end
    end

    visit channel_path(user, own_channel)

    page.should have_content(channel_to_follow.title)
  end
end
