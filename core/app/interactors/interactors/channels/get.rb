require_relative './index.rb'
module Interactors
  module Channels
    class AllById < Index
      arguments :id

      def get_alive_channels
        [Channel[@id]]
      end
    end
    class Get
      include Pavlov::Interactor
      arguments :id
      def execute
        channels = interactor :'channels/all_by_id', @id
        channels[0]
      end
      def authorized?
        @options[:current_user]
      end
    end
  end
end
