require_relative '../../app/classes/number_formatter'

class OpinionPresenter
  def initialize opinion
    @opinion = opinion
  end

  def belief_authority
    NumberFormatter.new(authority :b).as_authority
  end

  def disbelief_authority
   NumberFormatter.new(authority :d).as_authority
  end

  def relevance
    NumberFormatter.new(authority(:b) - authority(:d)).as_authority
  end

  def authority(type)
    @opinion.send(type) * @opinion.a
  end

  def to_hash
    {
      belief_authority: belief_authority,
      disbelief_authority: disbelief_authority,
      relevance: relevance
    }
  end
end
