require 'pavlov'

module Queries
  module Users
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        HandpickedTourUsers.new.members.map do |user|
          KillObject.user user
        end
      end

    end
  end
end
