require 'pavlov'

module Interactors
  module Mails
    class MassSendDigest
      include Pavlov::Interactor

      arguments :fact_id

      def execute
        mails.each do |mail|
          mail.deliver
        end
      end

      def mails
        fact = Fact[fact_id]
        User.receives_digest.map do |user|
          DigestMailer.discussion_of_the_week(user, fact)
        end
      end

      def authorized?
        true
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end
    end
  end
end
