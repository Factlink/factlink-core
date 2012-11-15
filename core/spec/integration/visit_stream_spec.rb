require 'integration_helper'

feature "visiting a channel" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include Acceptance::ScrollHelper

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  scenario "going to the channel page" do
    @channel = create_channel_in_backend

    visit channel_path(@user, @channel)

    page.should have_content(@channel.title)
  end
  
  scenario "shows facts" do
    @channel = create_channel_in_backend
    
    2.times.each do
      @factlink = create_fact_in_backend

      go_to_discussion_page_of @factlink

      open_modal 'Repost' do
        add_to_channel @channel.title
        added_channels_should_contain @channel.title
      end

      visit channel_path(@user, @channel)

      page.should have_content(@factlink.to_s)

      find('.text', text: @factlink.to_s)
    end
  end

  scenario "revisiting channel after visiting a factlink page" do
    @channel = create_channel_in_backend
    
    10.times.each do
      @factlink = create_fact_in_backend
      add_fact_to_channel_in_backend @factlink, @channel
    end

    go_to_channel_page_of @channel
    save_and_open_page

    set_scroll_top_to 100

    go_to_first_fact
    go_back_using_button
    
    expect(get_scroll_top).to eq(100)
  end
end
