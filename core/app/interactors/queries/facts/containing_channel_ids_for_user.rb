module Queries
  module Facts
    class ContainingChannelIdsForUser
      include Pavlov::Query

      arguments :fact, :pavlov_options

      def execute
        return [] unless pavlov_options[:current_user]

        channel_list.containing_real_channel_ids_for_fact(fact)
      end

      def channel_list
        ChannelList.new(pavlov_options[:current_user].graph_user)
      end
    end
  end
end
