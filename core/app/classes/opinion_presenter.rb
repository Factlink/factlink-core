class OpinionPresenter
  def initialize opinion
    @opinion = opinion
  end

  def relevance
    believes_authority - disbelieves_authority
  end

  def authority(type)
    @opinion.send(type) * @opinion.authority
  end

  def as_percentages_hash
    return zero_percentages_hash if @opinion.authority == 0

    believes, disbelieves = floored_percentages [@opinion.believes, @opinion.disbelieves, @opinion.doubts]

    doubts = 100 - believes - disbelieves

    {
      believe:    { percentage: believes },
      disbelieve: { percentage: disbelieves },
      doubt:      { percentage: doubts  },
      # TODO this logic should go elsewhere, but only after letting the update_opinion and
      #     remove opinion build proper json (instead of fact.to_json)
      authority: format(@opinion.authority)
    }
  end

  private

  def floored_percentages elements
    total = elements.inject(:+)
    elements.map do |element|
      ((100.0 * element)/total).floor.to_i
    end
  end

  def zero_percentages_hash
    {
      believe:    { percentage: 0 },
      disbelieve: { percentage: 0 },
      doubt:      { percentage: 100  },
      authority: format(0)
    }
  end

  def format number
    NumberFormatter.new(number).as_authority
  end

  def believes_authority
    authority :believes
  end

  def disbelieves_authority
    authority :disbelieves
  end
end
