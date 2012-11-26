class NumberFormatter
  def initialize nr
    @nr = nr
  end

  def as_authority
    sprintf("%.1f",@nr)
  end
end
