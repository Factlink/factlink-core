module Interactors
  module Groups
    class List
      include Pavlov::Interactor
      include Util::CanCan

      attribute :pavlov_options, Hash

      def authorized?
        can?(:list, Group)
      end

      private

      def execute
        Group.all.to_a
      end
    end
  end
end
