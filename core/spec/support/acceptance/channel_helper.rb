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
                                              pavlov_options: { current_user: channel.created_by.user }
    end
  end
end
