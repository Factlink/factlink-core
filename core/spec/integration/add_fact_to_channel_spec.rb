require 'integration_helper'

feature "adding a fact to a channel" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  scenario "adding a fact to a new channel from the factbubble" do
    pending 'Randomly fails'
    factlink = backend_create_fact
    new_channel_name = 'Gerrit'
    go_to_discussion_page_of factlink

    click_link('Repost')

    within(:css, ".modal-body") do
      page.should have_content('Repost this to one or more channels:')

      page.find(:css,'input').set(new_channel_name)

      page.find('li', text: new_channel_name).click

      added_channels_should_contain new_channel_name
    end
  end

  scenario "adding a fact to an existing channel from the factbubble" do
    @factlink = backend_create_fact
    @channel = backend_create_channel

    go_to_discussion_page_of @factlink

    open_modal 'Repost' do
      add_to_channel @channel.title
      added_channels_should_contain @channel.title
    end
  end

  scenario "the user can add a channel suggestion" do
    pending 'Randomly fails'
    # TODO: remove this when the channel_suggestions feature toggle is removed
    enable_features(@user, :channel_suggestions)

    site = FactoryGirl.create :site
    factlink = FactoryGirl.create :fact, created_by: @user.graph_user, site: site

    go_to_discussion_page_of factlink
    new_channel_name = 'Gerrit'

    open_modal 'Repost' do
      add_as_new_channel new_channel_name
      added_channels_should_contain new_channel_name
    end

    factlink2 = FactoryGirl.create :fact, created_by: @user.graph_user, site: site

    go_to_discussion_page_of factlink2

    open_modal 'Repost' do
      suggested_channels_should_contain new_channel_name
    end
  end

  scenario "adding an invalid channel shows an alert" do
    pending "to be implemented"
  end
end
