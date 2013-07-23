module Commands
  module Twitter
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id

      private

      def execute
        left_quotation_mark = "\u201c"
        right_quotation_mark = "\u201d"
        quote_with_url = left_quotation_mark + quote + right_quotation_mark + " " + url

        old_command :"twitter/post", quote_with_url
      end

      def quote
        long_quote = fact.displaystring.strip

        if long_quote.length > maximum_quote_length
          ellipsis = "\u2026"
          long_quote[0...maximum_quote_length-1].strip + ellipsis
        else
          long_quote
        end
      end

      def url
        @url ||= ::FactUrl.new(fact).sharing_url
      end

      def fact
        @fact ||= old_query :"facts/get_dead", fact_id
      end

      def maximum_quote_length
        short_url_length_https = ::Twitter.configuration.short_url_length_https
        tweet_length = 140
        space_before_url = 1
        quotation_marks = 2

        tweet_length - short_url_length_https - space_before_url - quotation_marks
      end

      def validate
        # HACK! Fix this through pavlov serialization (ask @markijbema or @janpaul123)
        if @options['serialize_id']
          @options = Util::PavlovContextSerialization.deserialize_pavlov_context(@options)
        end

        validate_integer_string  :fact_id, fact_id
      end
    end
  end
end
