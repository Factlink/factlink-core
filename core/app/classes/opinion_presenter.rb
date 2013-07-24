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

    l_believes_percentage    = calc_percentage(total, @opinion.believes)
    l_disbelieves_percentage = calc_percentage(total, @opinion.disbelieves)
    l_doubts_percentage      = 100 - l_believes_percentage - l_disbelieves_percentage

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

  def format number
    NumberFormatter.new(number).as_authority
  end

  def calc_percentage(total, part)
    if total > 0
      ((100 * part) / total).round.to_i
    else
      0
    end
  end

  def believes_authority
    authority :believes
  end

  def disbelieves_authority
    authority :disbelieves
  end
end
