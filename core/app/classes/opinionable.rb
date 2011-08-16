module Opinionable
  include Canivete::Deprecate
  # SCORE STUFF
  def score_dict_as_percentage

    op = get_opinion
    total = op.b + op.d + op.u

    return {
      :believe => {
        :percentage => calc_percentage(total, op.b).round,
      },
      :disbelieve => {
        :percentage => calc_percentage(total, op.d).round,
      },
      :doubt => {
        :percentage => calc_percentage(total, op.u).round,
      },
      :authority => op.a,
    }
  end
  
  def brain_cycles
    get_opinion.a.to_i
  end

  private
  def calc_percentage(total, part)
    if total > 0
      (100 * part) / total
    else
      0
    end
  end

end