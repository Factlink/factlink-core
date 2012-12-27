class UserOpinionCalculation

  def initialize believable, &block
    @believable = believable
    @authority_for = block
  end

  def opinion_types
    [:believes, :doubts, :disbelieves]
  end

  def users_with_opinion type
    @believable.opiniated(type)
  end

  def user_opinion user, type
    Opinion.for_type(type, @authority_for.call(user))
  end

  def opinion
    opinions = []
    opinion_types.each do |type|
      users_with_opinion(type).each do |user|
        opinions << user_opinion(user, type)
      end
    end
    Opinion.combine(opinions)
  end
end
