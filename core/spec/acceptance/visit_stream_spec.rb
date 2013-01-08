require 'acceptance_helper'

feature "visiting the stream" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include Acceptance::ScrollHelper

  background do
    @user = FactoryGirl.create :active_user
  end

  scenario "adding first fact" do
    channel = backend_create_channel
    factlink = backend_create_fact
    backend_add_fact_to_channel factlink, channel

    sign_in_user @user
    go_to_stream

    page.should have_content('just added their first Factlink')
    page.should have_content(factlink.to_s)
  end

  scenario "revisiting stream after visiting a factlink page" do
    channel = backend_create_channel

    other_user = FactoryGirl.create :active_user
    other_channel = backend_create_channel_of_user other_user
    backend_channel_add_subchannel channel, other_channel

    10.times.each do
      factlink = backend_create_fact_of_user other_user
      backend_add_fact_to_channel factlink, other_channel
    end

    sign_in_user @user
    go_to_stream

    sleep 1

    set_scroll_top_to 100

    go_to_first_fact
    go_back_using_button

    sleep 3

    scroll_top_should_eq 100
  end
end
