module Interactors
  module Groups
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      attribute :groupname, String
      attribute :creator, String
      attribute :pavlov_options, Hash

      def authorized?
        pavlov_options[:current_user].username == creator &&
          can?(:create, Group)
      end

      private

      def execute
        Backend::Group.create(
            groupname: groupname,
            members: [pavlov_options[:current_user]]
        )
      end

      def validate
        validate_nonempty_string :groupname, groupname
        validate_nonempty_string :creator, creator
      end
    end
  end
end
