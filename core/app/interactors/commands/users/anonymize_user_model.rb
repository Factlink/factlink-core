module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      def execute

      end
    end
  end
end
