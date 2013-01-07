require 'integration_helper'

feature "visiting a channel" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include Acceptance::ScrollHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user FactoryGirl.create :active_user
  end

  scenario "going to the channel page" do
    channel = backend_create_channel

    visit channel_path(@user, channel)

    page.should have_content(channel.title)
  end

  scenario "shows facts" do
    channel = backend_create_channel

    2.times.each do
      factlink = backend_create_fact

      go_to_discussion_page_of factlink

      open_modal 'Repost' do
        add_to_channel channel.title
        added_channels_should_contain channel.title
      end

      go_to_channel_page_of channel

      page.should have_content(factlink.to_s)
    end
  end

  scenario "revisiting channel after visiting a factlink page" do
    channel = backend_create_channel
    10.times.each do
      factlink = backend_create_fact
      backend_add_fact_to_channel factlink, channel
    end

    go_to_channel_page_of channel

    set_scroll_top_to 100

    go_to_first_fact
    go_back_using_button

    sleep 1

    scroll_top_should_eq 100
    page.should have_content(@factlink.to_s)
  end
end
