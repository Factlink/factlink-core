module Queries
  module Facts
    class Quote
      include Pavlov::Query

      private

      attribute :fact, Object
      attribute :max_length, Integer

      def execute
        left_quotation_mark = "\u201c"
        right_quotation_mark = "\u201d"

        left_quotation_mark + inner_quote + right_quotation_mark
      end

      def inner_quote
        long_quote = fact.displaystring.strip

        if long_quote.length > max_inner_quote_length
          ellipsis = "\u2026"

          long_quote[0...max_inner_quote_length-1].strip + ellipsis
        else
          long_quote
        end
      end

      def max_inner_quote_length
        max_length - 2
      end
    end
  end
end
