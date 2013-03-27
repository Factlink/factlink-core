module Interactors
  module Channels
    class Follow
      include Pavlov::Interactor

      arguments :channel_id

      def validate
        validate_integer_string :channel_id, channel_id
      end

      def execute
        success = command :'channels/add_subchannel', prospective_follower, channel
        if success
          command :'channels/added_subchannel_create_activities', prospective_follower, channel
        end
      end

      def channel
        @channel ||= query :'channels/get', channel_id
      end

      def prospective_follower
        @prospective_follower ||=
          query(:'channels/get_by_slug_title', channel.slug_title) ||
          command(:'channels/create', channel.title)
      end

      def authorized?
         # this is no stub, every user can follow another channel
        @options[:current_user]
      end

    end
  end
end
