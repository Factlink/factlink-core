module Acceptance
  module ChannelHelper
    def create_channel_in_backend
      create :channel, created_by: @user.graph_user
    end

    def add_fact_to_channel_in_backend fact, channel
      channel.add_fact fact
    end
  end
end
