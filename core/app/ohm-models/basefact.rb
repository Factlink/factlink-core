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

  def opiniated(type)
    send(:"people_#{Opinion.real_for(type)}")
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
    activity(user,Opinion.real_for(type),self)
  end

  def remove_opinions(user)
    _remove_opinions(user)
    activity(user,:removed_opinions,self)
  end

  def _remove_opinions(user)
    user.remove_opinions(self)
    Opinion.types.each do |type|
      delete_opiniated(type,user)
    end
  end
end