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
    total = @opinion.believes + @opinion.disbelieves + @opinion.doubts
    return zero_percentages_hash if @opinion.authority == 0 or total == 0


    l_believes_percentage    = ((100 * @opinion.believes) / total).floor.to_i
    l_disbelieves_percentage = ((100 * @opinion.disbelieves) / total).floor.to_i
    l_doubts_percentage      = ((100 * @opinion.doubts) / total).floor.to_i

    rest = 100 - l_believes_percentage - l_disbelieves_percentage - l_doubts_percentage

    l_doubts_percentage += rest

    {
      believe:    { percentage: l_believes_percentage },
      disbelieve: { percentage: l_disbelieves_percentage },
      doubt:      { percentage: l_doubts_percentage  },
      # TODO this logic should go elsewhere, but only after letting the update_opinion and
      #     remove opinion build proper json (instead of fact.to_json)
      authority: format(@opinion.authority)
    }
  end

  private

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

  def calc_percentage(total, part)

  end

  def believes_authority
    authority :believes
  end

  def disbelieves_authority
    authority :disbelieves
  end
end
