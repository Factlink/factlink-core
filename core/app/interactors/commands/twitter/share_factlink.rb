module Commands
  module Twitter
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id

      private

      def execute
        quote_with_url = quote + ' ' + url

        command(:'twitter/post', message: quote_with_url)
      end

      def quote
        query :'facts/quote', fact: fact, max_length: maximum_quote_length
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

        validate_integer_string  :fact_id, fact_id
      end
    end
  end
end
