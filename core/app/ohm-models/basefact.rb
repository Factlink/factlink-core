class Basefact < OurOhm
  include ActivitySubject
  
  reference :created_by, GraphUser
  reference :opinion, Opinion

  set :people_beliefs, GraphUser
  set :people_believes, GraphUser
  set :people_doubts, GraphUser
  set :people_disbeliefs, GraphUser
  set :people_disbelieves, GraphUser
  private :people_beliefs, :people_believes, :people_doubts, :people_disbeliefs, :people_disbelieves


  def validate
    assert_present :created_by
  end


  def opiniated(type)
    type = type.to_sym
    if [:beliefs,:believes].include?(type)
      ( people_beliefs | people_believes )
    elsif [:doubts].include?(type)
      people_doubts
    elsif [:disbeliefs,:disbelieves].include?(type)
      ( people_disbeliefs | people_disbelieves )
    else
      raise "invalid opinion"
    end
  end

  def add_opiniated(type, user)
    send("people_#{type}").add(user)
  end
  
  def delete_opiniated(type, user)
    send("people_#{type}").delete(user)
  end

  def opiniated_count(type)
    opiniated(type).size
  end

  def add_opinion(type, user)    
    _remove_opinions(user)

    add_opiniated(type,user)
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
      delete_opiniated(type,user)
    end
  end


  value_reference :user_opinion, Opinion
  def calculate_user_opinion(depth=0)
    #depth has no meaning here unless we want the depth to also recalculate authorities
    opinions = []
    [:beliefs, :doubts, :disbeliefs].each do |type|      
      opiniated = opiniated(type)
      opiniated.each do |user|
        opinions << Opinion.for_type(type, user.authority)
      end
    end
    self.user_opinion = Opinion.combine(opinions)
    save
  end

  def get_user_opinion(depth=0)
    if depth > 0
      self.calculate_user_opinion(depth)
    end
    self.user_opinion || Opinion.identity
  end
  
  def activities
    Activity.find({
      :subject_id => self.id,
      :subject_class => self.class
    })
  end
  
  private :delete
  
end