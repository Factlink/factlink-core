require_relative '../../app/classes/number_formatter'

class OpinionPresenter
  def initialize opinion
    @opinion = opinion
  end

  def belief_authority
    authority :beliefs
  end

  def formatted_belief_authority
    format belief_authority
  end

  def disbelief_authority
    authority :disbeliefs
  end

  def formatted_disbelief_authority
    format disbelief_authority
  end

  def relevance
    belief_authority - disbelief_authority
  end

  def formatted_relevance
    format relevance
  end

  def authority(type)
    @opinion.send(type) * @opinion.authority
  end

  def format number
    NumberFormatter.new(number).as_authority
  end

  def as_percentages_hash
    total = @opinion.b + @opinion.d + @opinion.u

    l_believe_percentage = calc_percentage(total, @opinion.b)
    l_disbelieve_percentage = calc_percentage(total, @opinion.d)
    l_doubt_percentage = 100 - l_believe_percentage - l_disbelieve_percentage

    {
      believe:    { percentage: l_believe_percentage },
      disbelieve: { percentage: l_disbelieve_percentage },
      doubt:      { percentage: l_doubt_percentage  },
      # TODO this logic should go elsewhere, but only after letting the update_opinion and
      #     remove opinion build proper json (instead of fact.to_json)
      authority: format(@opinion.a)
    }
  end

  def to_hash
    {
      formatted_belief_authority: formatted_belief_authority,
      formatted_disbelief_authority: formatted_disbelief_authority,
      formatted_relevance: formatted_relevance,
    }
  end

  private

  def calc_percentage(total, part)
    if total > 0
      ((100 * part) / total).round.to_i
    else
      0
    end
  end
end
