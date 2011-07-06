
module Opinionable
  # SCORE STUFF
  def score_dict_as_percentage
    op = get_opinion
    total = op.b + op.d + op.u

    return {
      :believe => {
        :percentage => percentage(total, op.b),
      },
      :doubt => {
          :percentage => percentage(total, op.d),
      },
      :disbelieve => {
          :percentage => percentage(total, op.u),
      },
      :authority => op.a,
    }
  end

   
 

    # Percentual scores
    def percentage_score_believe
      score_dict_as_percentage[:believe][:percentage]
    end

    def percentage_score_doubt
      score_dict_as_percentage[:doubt][:percentage]
    end

    def percentage_score_disbelieve
      score_dict_as_percentage[:disbelieve][:percentage]
    end



    def percentage(total, part)
      if total > 0
        (100 * part) / total
      else
        0
      end
    end


end