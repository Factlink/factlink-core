module Interactors
  module Groups
    class AddMember
      include Pavlov::Interactor
      include Util::CanCan

      attribute :pavlov_options, Hash
      attribute :username, String
      attribute :groupname, String

      def authorized?
        pavlov_options[:import] || can?(:access, Group.where(groupname: groupname).first)
      end

      private

      def execute
        Backend::Groups.add_member(
            groupname: groupname,
            username: username
        )
      end

      def validate
        validate_nonempty_string :groupname, groupname
        validate_nonempty_string :username, username
      end
    end
  end
end
