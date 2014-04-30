module Interactors
  module Groups
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      attribute :groupname
      attribute :members
      attribute :pavlov_options, Hash

      def authorized?
        pavlov_options[:import] || can?(:create, Group)
      end

      private

      def execute
        Backend::Groups.create(groupname: groupname, usernames: members)
      end

      def validate
        validate_nonempty_string :groupname, groupname

        unless members.is_a?(Array) && members.all?{|o| o.is_a?(String)}
          errors.add :members, 'should be an array of strings'
        end
      end
    end
  end
end
