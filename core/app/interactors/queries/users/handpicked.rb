require 'pavlov'

module Queries
  module Users
    class Handpicked
      include Pavlov::Query

      def execute
        HandpickedTourUsers.new.members.map do |user|
          KillObject.user user
        end
      end
    end
  end
end
