class TrimmedString

  def initialize string
    @string = string
  end

  def trimmed max_length
    long_string = @string.strip

    if long_string.length > max_length
      ellipsis = "\u2026"

      long_string[0...max_length-1].strip + ellipsis
    else
      long_string
    end
  end

  def trimmed_quote max_length
    left_quotation_mark = "\u201c"
    right_quotation_mark = "\u201d"

    left_quotation_mark + trimmed(max_length-2) + right_quotation_mark
  end

end
