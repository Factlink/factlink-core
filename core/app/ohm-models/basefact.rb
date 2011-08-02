class Basefact < OurOhm
  include Opinionable

  reference :site, Site       # The site on which the factlink should be shown
  def url=(url)
    self.site = Site.find_or_create_by(url)
  end
  def url
    self.site.url
  end

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
    url.gsub(/http(s?):\/\//,'').split('/')[0]
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