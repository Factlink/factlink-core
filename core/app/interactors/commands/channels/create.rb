require 'pavlov'

module Commands
  module Channels
    class Create
      include Pavlov::Query

      arguments :title

      def execute
          channel = Channel.new(title:title, created_by_id:@options[:current_user].graph_user_id)

          channel.save

          channel
      end

    end
  end
end

