module Interactors
  module Groups
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      attribute :groupname, String
      attribute :members, [String]
      attribute :pavlov_options, Hash

      def authorized?
        pavlov_options[:import] || can?(:create, Group)
      end

      private

      def execute
        Backend::Groups.create(
            groupname: groupname,
            usernames: members
        )
      end

      def validate
        validate_nonempty_string :groupname, groupname
      end
    end
  end
end
