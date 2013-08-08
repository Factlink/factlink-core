module Interactors
  module Mails
    class MassSendDigest
      include Pavlov::Interactor

      arguments :fact_id, :url

      def execute
        mails.each do |mail|
          mail.deliver
        end
      end

      def mails
        User.receives_digest.map do |user|
          DigestMailer.discussion_of_the_week(user.id, fact.id, url)
        end
      end

      def fact
        @fact ||= Fact[fact_id]
      end

      def authorized?
        true
      end

      def validate
        validate_integer_string :fact_id, fact_id
        validate_string :url, url
      end
    end
  end
end
