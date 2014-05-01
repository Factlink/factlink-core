module Interactors
  module Groups
    class AddMember
      include Pavlov::Interactor
      include Util::CanCan

      attribute :pavlov_options, Hash
      attribute :username, String
      attribute :group_id, String

      def authorized?
        pavlov_options[:import] || can?(:access, Group.find_by(id: group_id))
      end

      private

      def execute
        Backend::Groups.add_member(
            group_id: group_id,
            username: username
        )
      end

      def validate
        validate_integer_string :group_id, group_id
        validate_nonempty_string :username, username
      end
    end
  end
end
