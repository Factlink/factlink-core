module Commands
  module Channels
    class AddFact
      include Pavlov::Command

      arguments :fact, :channel

      def execute
        @channel.sorted_delete_facts.delete(@fact)
        @channel.sorted_internal_facts.add(@fact)
        @channel.add_created_channel_activity
        Resque.enqueue(AddFactToChannelJob, @fact.id, @channel.id, initiated_by_id: @channel.created_by_id)
      end
    end
  end
end
