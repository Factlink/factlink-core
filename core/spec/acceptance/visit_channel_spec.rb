require 'acceptance_helper'

feature "visiting a channel" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user create :active_user
  end

  scenario "going to the channel page" do
    channel = backend_create_channel

    visit channel_path(@user, channel)

    page.should have_content(channel.title)
  end

  scenario "shows facts" do
    channel = backend_create_channel

    2.times do
      factlink = backend_create_fact

      go_to_discussion_page_of factlink

      open_repost_modal do
        add_to_channel channel.title
        added_channels_should_contain channel.title
      end

      go_to_channel_page_of channel

      page.should have_content(factlink.to_s)
    end
  end
end
