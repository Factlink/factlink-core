require 'pavlov'

module Commands
  module Channels
    class Create
      include Pavlov::Query

      arguments :title
      attribute :pavlov_options, Hash, default: {}

      def validate
        validate_string :title, @title
      end

      def execute
        channel = Channel.new title:title,
                     created_by_id: current_graph_user_id
        channel.save
        channel
      end

      def current_graph_user_id
        pavlov_options[:current_user].graph_user_id
      end
    end
  end
end

