# config/initializers/resque_mailer.rb
Resque::Mailer.excluded_environments = [:test]

module Devise
  module Mailers
    module Helpers
      def initialize_from_record(user_hash_or_object)
        super get_user_for_hash_or_object(user_hash_or_object)
      end

      def get_user_for_hash_or_object(hash_or_object)
        if hash_or_object.kind_of?(Hash)
          User.where(email: hash_or_object['email']).first
        else
          hash_or_object
        end
      end
    end
  end
end
