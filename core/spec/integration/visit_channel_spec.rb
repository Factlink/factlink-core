require 'integration_helper'

feature "visiting a channel" do
  include Acceptance::ChannelHelper

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

      find('.text', text: @factlink.to_s)
    end
  end

  scenario "revisiting channel after visiting a factlink page" do
    @channel = create_channel_in_backend
    
    10.times.each do
      @factlink = create_fact_in_backend
      @channel.add_fact(@factlink)
    end

    visit channel_path(@user, @channel)
    save_and_open_page

    page.execute_script('$("body").scrollTo(100);')

    find('.permalink a').click

    find('.titleRegion a.btn-back').click

    expect(page.evaluate_script('$("body").scrollTop();')).to eq(100)
  end
end
