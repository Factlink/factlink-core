require 'pavlov'

module Queries
  module Users
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        HandpickedTourUsers.new.members
      end

    end
  end
end
