require_relative '../../app/classes/number_formatter'

class OpinionPresenter
  def initialize opinion
    @opinion = opinion
  end

  def belief_authority
    authority :b
  end

  def disbelief_authority
    authority :d
  end

  def authority(type)
    NumberFormatter.new(@opinion.send(type) * @opinion.a).as_authority
  end

  def to_hash
    {
      belief_authority: belief_authority,
      disbelief_authority: disbelief_authority
    }
  end
end
