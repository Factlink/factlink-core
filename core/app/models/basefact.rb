require File.expand_path("../../classes/opinionable.rb", __FILE__)
require File.expand_path("../../classes/opinion.rb", __FILE__)

module FactDataProxy
  #assuming we have a data
  def title
    require_data
    data.title
  end

  def title=(value)
    require_data
    data.title=value
  end

  def displaystring
    require_data
    data.displaystring
  end

  def displaystring=(value)
    require_data
    data.displaystring=value
  end 

  def content
    require_data
    data.content
  end

  def content=(value)
    require_data
    data.content=value
  end

  def passage
    require_data
    data.passage
  end

  def passage=(value)
    require_data
    data.passage=value
  end

  def created_at
    require_data
    data.created_at
  end

  def updated_at
    require_data
    data.updated_at
  end


  def require_data
    if not self.data_id
      localdata = FactData.new
      localdata.save
      self.data = localdata
      save
    end
  end

  def post_save
    require_data
    data.save
  end

end

class Basefact < OurOhm
  include FactDataProxy
  include Opinionable

  reference :data, lambda { |id| FactData.find(id) }

  reference :site, Site       # The site on which the factlink should be shown


  reference  :created_by, GraphUser

  #scope :with_site_as_parent, where( :_id.in => Site.all.map { |s| s.facts.map { |f| f.id } }.flatten )

  #value :added_to_factlink

  # TODO: Find another way to retrieve all factlinks that have a relation to a site
  # scope :with_site, where( :site.ne => nil ) # is not working.
  # def self.with_site_as_parent
  #   # Map all site, and all factlinks in this site.
  #   factlink_ids = Site.all.map { |s| s.facts.map { |f| f.id } }.flatten
  #   self.where( :_id.in => factlink_ids )
  # end


  #deze snel deprecaten, want deze overschrijft de ohm-eigen dingen
  deprecate
  def self.find(id)
    return self[id]
  end

  set :people_beliefs, GraphUser
  set :people_doubts, GraphUser
  set :people_disbeliefs, GraphUser
  def opiniated(type)
    self.send("people_#{type}")
  end

  def opiniated_count(type)
    opiniated(type).size
  end


  def to_s
    self.displaystring || ""
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
