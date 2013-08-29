module Acceptance
  module ChannelHelper
    def backend_create_channel
      backend_create_channel_of_user @user
    end

    def backend_create_channel_of_user user, options={}
      create :channel, {created_by: user.graph_user}.merge(options)
    end

    def backend_create_viewable_channel_for user, options={}
      channel = backend_create_channel_of_user user, options
      fact = create :fact, created_by: user.graph_user
      backend_add_fact_to_channel fact, channel
      channel
    end

    def backend_add_fact_to_channel fact, channel
      Pavlov.interactor :'channels/add_fact', fact: fact, channel: channel,
        pavlov_options: { no_current_user: true }
    end

    def go_to_channel_page_of channel
      path = channel_path @user, channel
      visit path
    end

    def go_to_stream
      find('#left-column .js-stream a').click
    end

    def go_to_first_fact
      first('a.discussion_link', text: 'Arguments').click
    end

    def assert_on_channel_page channel_title
      # wait until the new header with the new title appears
      find('#channel > header h1', text: channel_title)
    end

    def assert_on_stream
      find('#channel > header h1', text: 'Feed')
    end

    def within_channel_header &block
      within(:css, "#channel > header") do
        yield
      end
    end
  end
end
