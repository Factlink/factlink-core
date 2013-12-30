module Commands
  module Twitter
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id, :message

      private

      def execute
        command :'twitter/post', message: message_or_quote + ' ' + url
      end

      def message_or_quote
        if message
          TrimmedString.new(message).trimmed(maximum_quote_length)
        else
          fact.trimmed_quote(maximum_quote_length)
        end
      end

      def url
        @url ||= ::FactUrl.new(fact).sharing_url
      end

      def fact
        @fact ||= query(:'facts/get_dead', id: fact_id)
      end

      def maximum_quote_length
        short_url_length_https = ::Twitter.configuration.short_url_length_https
        tweet_length = 140
        space_before_url = 1

        tweet_length - short_url_length_https - space_before_url
      end

      def validate
        # HACK! Fix this through pavlov serialization (ask @markijbema or @janpaul123)
        if pavlov_options.has_key? 'serialize_id'
          self.pavlov_options = Util::PavlovContextSerialization.deserialize_pavlov_context(pavlov_options)
        end
      end
    end
  end
end
