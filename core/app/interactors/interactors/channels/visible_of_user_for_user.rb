require_relative './index.rb'
module Interactors
  module Channels
    class VisibleOfUserForUser < Index
      arguments :user

      def get_alive_channels
        query :visible_channels_of_user, @user
      end
      def channel_user ch
        @user
      end
    end
  end
end
