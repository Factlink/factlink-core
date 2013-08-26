require 'acceptance_helper'

feature "visiting the stream" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include Acceptance::ScrollHelper
  include PavlovSupport

  background do
    @user = create :active_user
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
    pending "this tests fails too much randomly to give any useful feedback"
    channel = backend_create_channel

    other_user = create :active_user
    other_channel = backend_create_channel_of_user other_user

    as(@user) do |p|
      p.interactor :'channels/add_subchannel', channel.id, other_channel.id
    end

    10.times.each do
      factlink = backend_create_fact_of_user other_user
      backend_add_fact_to_channel factlink, other_channel
    end

    sign_in_user @user

    go_to_stream
    go_to_first_fact
    go_to_stream
    assert_on_stream

    sleep 1
    set_scroll_top_to 100
    go_to_first_fact
    go_back_using_button #This is deprecated, closing the modal with the new close button
    sleep 6
    scroll_top_should_eq 100
  end
end
