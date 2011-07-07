module Opinionable
  # SCORE STUFF
  def score_dict_as_percentage
    
    return {
      :believe => {
        :percentage => 37,
      },
      :disbelieve => {
        :percentage => 49,
      },
      :doubt => {
        :percentage => 14,
      },
      
      :authority => 102,
    }
    
    
    op = get_opinion
    total = op.b + op.d + op.u

    return {
      :believe => {
        :percentage => percentage(total, op.b),
      },
      :disbelieve => {
        :percentage => percentage(total, op.d),
      },
      :doubt => {
        :percentage => percentage(total, op.u),
      },
      
      :authority => op.a,
    }
  end
  
  def brain_cycles
    get_opinion.a.to_i
  end

  # Percentual scores
  deprecate
  def percentage_score_believe
    score_dict_as_percentage[:believe][:percentage]
  end

  deprecate
  def percentage_score_disbelieve
    score_dict_as_percentage[:disbelieve][:percentage]
  end
  
  deprecate
  def percentage_score_uncertain
    score_dict_as_percentage[:doubt][:percentage]
  end



  def percentage(total, part)
    if total > 0
      (100 * part) / total
    else
      0
    end
  end

end
