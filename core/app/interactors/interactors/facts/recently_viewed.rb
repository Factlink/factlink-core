module Interactors
  module Facts
    class RecentlyViewed
      include Pavlov::Interactor
      include Util::CanCan

      arguments

      def execute
        return [] unless pavlov_options[:current_user]

        Backend::Facts.recently_viewed user_id: pavlov_options[:current_user].id
      end

      def authorized?
        true
      end
    end
  end
end
