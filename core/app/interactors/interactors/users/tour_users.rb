module Interactors
  module Users
    class TourUsers
      include Pavlov::Interactor
      include Util::CanCan

      def execute
        query :"users/handpicked"
      end

      def authorized?
        can? :index, User
      end
    end
  end
end
