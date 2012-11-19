module Acceptance
  module ChannelHelper
    def backend_create_channel
      backend_create_channel_of_user @user
    end

    def backend_create_channel_of_user user
      create :channel, created_by: user.graph_user
    end

    def backend_add_fact_to_channel fact, channel
      channel.add_fact fact
    end

    def backend_channel_add_subchannel channel, subchannel
      channel.add_channel(subchannel)
    end

    def go_to_channel_page_of channel
      path = channel_path @user, channel
      visit path
    end

    def go_to_stream
      find('#left-column .stream a').click
    end

    def go_to_first_fact
      find('a.discussion_link').click
    end
  end
end
