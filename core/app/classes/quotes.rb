class Quotes

  def initialize string
    @string = string
  end

  def trimmed_quote max_length
    left_quotation_mark = "\u201c"
    right_quotation_mark = "\u201d"

    left_quotation_mark + inner_quote(max_length-2) + right_quotation_mark
  end

  private

  def inner_quote max_length
    long_quote = @string.strip

    if long_quote.length > max_length
      ellipsis = "\u2026"

      long_quote[0...max_length-1].strip + ellipsis
    else
      long_quote
    end
  end

end
