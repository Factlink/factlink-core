module Interactors
  module Facts
    class RecentlyViewed
      include Pavlov::Interactor
      include Util::CanCan

      arguments

      def execute
        return [] unless pavlov_options[:current_user]

        Backend::Facts.recently_viewed graph_user_id: pavlov_options[:current_user].graph_user_id
      end

      def authorized?
        can? :index, Fact
      end
    end
  end
end
