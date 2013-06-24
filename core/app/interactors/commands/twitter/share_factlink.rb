module Commands
  module Twitter
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id

      private

      def execute
        # "\u201c" = left quote
        # "\u201d" = right quote
        quote_with_url = "\u201c" + quote + "\u201d " + url

        command :"twitter/post", quote_with_url
      end

      def quote
        long_quote = fact.displaystring.strip

        if long_quote.length > maximum_quote_length
          # adds single ellipsis character
          long_quote[0...maximum_quote_length-1].strip + "\u2026"
        else
          long_quote
        end
      end

      def url
        @url ||= ::FactUrl.new(fact).sharing_url
      end

      def fact
        @fact ||= query :"facts/get_dead", fact_id
      end

      def maximum_quote_length
        short_url_length_https = ::Twitter.configuration.short_url_length_https

        140 - short_url_length_https - 3 # -1 for space, -2 for quotation marks
      end

      def validate
        validate_integer_string  :fact_id, fact_id
      end
    end
  end
end
