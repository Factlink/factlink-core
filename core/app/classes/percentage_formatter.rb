class PercentageFormatter
  
  def initialize(round_to, minimum)
    @round_to = round_to
    @minimum = minimum
  end

  def round_percentages(percentages)
    total = percentages.reduce(0,:+)
    percentages.map {|x| ((x.to_f / @round_to )).round.to_i * @round_to }
  end

  def cap_percentages(percentages)
    round_to = @round_to
    minimum = @minimum
    
    percentages = round_percentages(percentages)
    total = percentages.reduce(0,:+)
    after_total, large_ones = 0, 0
    percentages.each do |percentage|
      after_total += [percentage, minimum].max
      if percentage > (100 - minimum)/2
        large_ones += percentage 
      end
    end
    too_much = after_total - 100
    return percentages.map do |percentage|
      if percentage < minimum
        percentage = minimum
      elsif percentage > (100-minimum)/2
        percentage = percentage - percentage/large_ones*too_much
      end
      percentage
    end
  end
  
end