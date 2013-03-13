module Interactors
  module Channels
    class Follow
      include Pavlov::Interactor

      arguments :channel_id

      def validate
        validate_integer_string :channel_id, channel_id
      end

      def execute
        # raise 'not found' unless channel and subchannel
        command :'channels/add_subchannel', prospective_follower, channel
      end

      def channel
        @channel ||= Channel[channel_id]
      end

      def prospective_follower
        query_result = query :'channels/get_by_slug_title', channel.slug_title
        if query_result.nil?
          command :'channels/create', channel.title
        else
          query_result
        end
      end

      def authorized?
         # this is no stub, every user can follow another channel
        @options[:current_user]
      end

    end
  end
end
