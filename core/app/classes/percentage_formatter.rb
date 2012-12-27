class PercentageFormatter

  def initialize(round_to, minimum)
    @round_to = round_to
    @minimum = minimum
  end

  DOUBT_INDEX = 1

  def floor_percentages(percentages)
    percentages.map {|x| ((x.to_f / @round_to )).floor.to_i * @round_to }
  end

  def cap_percentages(percentages)
    minimum = @minimum

    after_total, large_ones = 0.0, 0.0
    percentages.each do |percentage|
      after_total += [percentage, minimum].max
      if percentage > (100 - minimum)/2
        large_ones += percentage
      end
    end
    too_much = after_total - 100
    percentages = percentages.map do |percentage|
      if percentage < minimum
        percentage = minimum
      elsif percentage > (100-minimum)/2
        percentage = percentage - percentage/large_ones*too_much
      end
      percentage.round
    end
  end

  def process_percentages(percentages)
    percentages = cap_percentages(percentages)
    percentages = floor_percentages(percentages)
    percentages[DOUBT_INDEX] += 100 - percentages.reduce(0,:+)
    percentages
  end

end
