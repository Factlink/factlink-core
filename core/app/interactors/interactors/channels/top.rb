require_relative './index.rb'
module Interactors
  module Channels
    class Top < Index
      arguments

      def get_alive_channels
        top_topics(12).map {|t| t.top_channels_with_fact(1).first }
                      .delete_if {|ch| ch.nil?}
      end

      # DUPLICATED FROM TOPICS CONTROLLER
      # should be extracted to query
      def top_topics(nr)
        Topic.top(nr+2).delete_if {|t| t.nil? or ['created','all'].include? t.slug_title}
      end

    end
  end
end
