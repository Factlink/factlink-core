module Commands
  module Activities
    class CleanList
      include Pavlov::Command
      arguments :list_key

      private

      def execute
        # the redis lib does not seem to accept removal of multiple elements
        members_to_remove.each do |member_id|
          list.zrem member_id
        end
      end

      def list
        @list ||= Nest.new(list_key)
      end

      def members_to_remove
        list.zrange(0,-1).select do |id|
          a = Activity[id]
          a.nil?
        end
      end

    end
  end
end
