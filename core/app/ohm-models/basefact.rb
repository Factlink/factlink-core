autoload :Basefact, 'basefact'
autoload :Fact, 'fact'
autoload :FactRelation, 'fact_relation'
autoload :GraphUser, 'graph_user'
autoload :OurOhm, 'our_ohm'
autoload :Site, 'site'

autoload :Opinion, 'opinion'
autoload :Opinionable, 'opinionable'

#dirty hack, sorry:
module Opinionable
end


class Basefact < OurOhm
  include Opinionable

  reference :site, Site       # The site on which the factlink should be shown
  reference :created_by, GraphUser

  set :people_beliefs, GraphUser
  set :people_doubts, GraphUser
  set :people_disbeliefs, GraphUser
  def opiniated(type)
    self.send("people_#{type}")
  end

  def opiniated_count(type)
    opiniated(type).size
  end

  # Return a nice looking url, only subdomain + domain + top level domain
  def pretty_url
    self.site.url.gsub(/http(s?):\/\//,'').split('/')[0]
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
    remove_opinions(user)
    opiniated(type).add(user)
    user.update_opinion(type, self)
  end

  def remove_opinions(user)
    user.remove_opinions(self)
    [:beliefs, :doubts, :disbeliefs].each do |type|
      opiniated(type).delete(user)
    end
  end

  def interacting_users
    opiniated(:beliefs).all + opiniated(:doubts).all + opiniated(:disbeliefs).all
  end

  def get_opinion
    # Primitive loop detection; not working correct
    # key = "loop_detection"
    # 
    # if $redis.sismember(key, self.id)
    #   $redis.del(key)      
    #   return Opinion.new(0, 0, 0)
    # else
    #   $redis.sadd(key, self.id)
    #   
    #   opinions = []
    #   [:beliefs, :doubts, :disbeliefs].each do |type|      
    #     opiniated = opiniated(type)
    #     opiniated.each do |user|
    #       opinions << Opinion.for_type(type, user.authority)
    #     end
    #   end
    #   return Opinion.combine(opinions)      
    # end

    # Return this if the loop detection is not used:
    opinions = []
    [:beliefs, :doubts, :disbeliefs].each do |type|      
      opiniated = opiniated(type)
      opiniated.each do |user|
        opinions << Opinion.for_type(type, user.authority)
      end
    end
    Opinion.combine(opinions)
  end

end