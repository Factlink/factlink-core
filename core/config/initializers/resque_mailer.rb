# config/initializers/resque_mailer.rb
Resque::Mailer.excluded_environments = [:test, :development]

module Devise
  module Mailers
    module Helpers
      def hack_record(record)
        record.kind_of?(Hash) ? kmodel(record).where(:email=>record['email']).first : record
      end

      def kmodel(record)
        User
      end
    end
  end
end
