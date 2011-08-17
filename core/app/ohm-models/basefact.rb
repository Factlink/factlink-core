class Basefact < OurOhm
  include ActivitySubject
  
  reference :user_opinion, Opinion
  reference :created_by, GraphUser
  reference :opinion, Opinion

  set :people_beliefs, GraphUser
  set :people_doubts, GraphUser
  set :people_disbeliefs, GraphUser

  def validate
    assert_present :created_by
  end


  def opiniated(type)
    self.send("people_#{type}")
  end

  def opiniated_count(type)
    opiniated(type).size
  end

  def toggle_opinion(type, user)
    if opiniated(type).include?(user)
      # User has this opinion already; remove opinion
      remove_opinions(user)
    else
      # User has none or other opinion, set this one!
      add_opinion(type, user)
    end
  end

  def add_opinion(type, user)    
    _remove_opinions(user)

    opiniated(type).add(user)
    user.update_opinion(type, self)
    activity(user,type,self)
  end

  def remove_opinions(user)
    _remove_opinions(user)
    activity(user,:removed_opinions,self)
  end
  
  def _remove_opinions(user)
    user.remove_opinions(self)
    [:beliefs, :doubts, :disbeliefs].each do |type|
      opiniated(type).delete(user)
    end
  end

  def calculate_user_opinion
    opinions = []
    [:beliefs, :doubts, :disbeliefs].each do |type|      
      opiniated = opiniated(type)
      opiniated.each do |user|
        opinions << Opinion.for_type(type, user.authority)
      end
    end
    self.user_opinion = Opinion.combine(opinions).save
    save
  end
  
  def get_user_opinion
    self.user_opinion || Opinion.identity
  end
  
end