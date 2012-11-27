class NumberFormatter
  def initialize nr
    @nr = nr
  end

  def as_authority
    absolute_number = @nr.abs

    if @nr < 0
      prefix = "-"
    else
      prefix = ""
    end

    if absolute_number < 15
      sprintf("#{prefix}%.1f", absolute_number)
    elsif absolute_number >= 1000
      sprintf("#{prefix}%.0fk", absolute_number.div(1000))
    else
      sprintf("#{prefix}%.0f",absolute_number)
    end
  end
end
