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

  def to_hash
    {
      formatted_belief_authority: formatted_belief_authority,
      formatted_disbelief_authority: formatted_disbelief_authority,
      formatted_relevance: formatted_relevance,
    }
  end
end
