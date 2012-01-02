class Basefact < OurOhm
  include Activity::Subject

  reference :created_by, GraphUser
  reference :opinion, Opinion

  set :people_believes, GraphUser
  set :people_doubts, GraphUser
  set :people_disbelieves, GraphUser
  private :people_believes, :people_doubts, :people_disbelieves
  def opinionated_users
    return people_believes | people_doubts | people_disbelieves
  end

  def validate
    assert_present :created_by
  end

  def real_opinion(type)
    type = type.to_sym
    if [:beliefs,:believes].include?(type)
      :believes
    elsif [:doubts].include?(type)
      :doubts
    elsif [:disbeliefs,:disbelieves].include?(type)
      :disbelieves
    else
      raise "invalid opinion"
    end
  end

  def opiniated(type)
    type = real_opinion(type)
    belief_check(type)
    if [:beliefs,:believes].include?(type)
      people_believes
    elsif [:doubts].include?(type)
      people_doubts
    elsif [:disbeliefs,:disbelieves].include?(type)
      people_disbelieves
    else
      raise "invalid opinion"
    end
  end

  def add_opiniated(type, user)
    opiniated(type).add(user)
  end

  def delete_opiniated(type, user)
    opiniated(type).delete(user)
  end

  def opiniated_count(type)
    opiniated(type).size
  end

  def add_opinion(type, user)
    _remove_opinions(user)

    add_opiniated(type,user)
    user.update_opinion(type, self)
    activity(user,real_opinion(type),self)
  end

  def remove_opinions(user)
    _remove_opinions(user)
    activity(user,:removed_opinions,self)
  end

  def _remove_opinions(user)
    user.remove_opinions(self)
    [:believes, :doubts, :disbelieves].each do |type|
      delete_opiniated(type,user)
    end
  end


  opinion_reference :user_opinion do |depth|
    #depth has no meaning here unless we want the depth to also recalculate authorities
    opinions = []
    [:believes, :doubts, :disbelieves].each do |type|
      opiniated = opiniated(type)
      opiniated.each do |user|
        opinions << Opinion.for_type(type, user.authority)
      end
    end
    Opinion.combine(opinions)
  end

  private :delete

end