require 'integration_helper'

feature "adding a fact to a channel" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  scenario "adding a fact to a new channel from the factbubble" do
    @factlink = backend_create_fact

    go_to_discussion_page_of @factlink

    open_modal 'Repost' do
      page.should have_content('Repost this to one or more channels:')

      add_as_new_channel 'Gerrit'

      sleep 1

      added_channels_should_contain 'Gerrit'
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

  scenario "adding an invalid channel shows an alert" do
    pending "to be implemented"
  end

end
