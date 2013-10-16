require 'acceptance_helper'

feature "adding a fact to a channel" do
  include Acceptance
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user create :full_confirmed_user
  end

  scenario "adding a fact to a new channel from the factbubble" do
    factlink = backend_create_fact
    new_channel_name = 'Gerrit'
    go_to_discussion_page_of factlink

    open_repost_modal do
      page.should have_content('Repost this to one or more topics:')

      add_as_new_channel new_channel_name
      added_channels_should_contain new_channel_name
    end
  end

  scenario "adding a fact to an existing channel from the factbubble" do
    @factlink = backend_create_fact
    @channel = backend_create_channel

    go_to_discussion_page_of @factlink

    open_repost_modal do
      add_to_channel @channel.title
      added_channels_should_contain @channel.title
    end
  end

  scenario "the user can add a channel suggestion" do
    site = create :site
    factlink = create :fact, created_by: @user.graph_user, site: site

    go_to_discussion_page_of factlink
    new_channel_name = 'Gerrit'

    open_repost_modal do
      add_as_new_channel new_channel_name
      added_channels_should_contain new_channel_name
    end

    factlink2 = create :fact, created_by: @user.graph_user, site: site

    go_to_discussion_page_of factlink2

    open_repost_modal do
      suggested_channels_should_contain new_channel_name
    end
  end
end
