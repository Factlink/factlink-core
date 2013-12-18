module Interactors
  module Channels
    class VisibleOfUserForUser
    include Pavlov::Interactor
      include Util::CanCan

      arguments :user

      def execute
        visible_channels.map do |ch|
          KillObject.channel ch
        end
      end

      def visible_channels
        query(:'visible_channels_of_user', user: user)
      end

      def authorized?
        can? :index, Channel
      end
    end
  end
end
