require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new

class Basefact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid
  include Redis::Objects
  
  include Opinionable

  searchable :auto_index => true do
    text    :displaystring
    string  :displaystring
    time    :created_at
  end

  field :title,           :type => String
  field :displaystring,   :type => String   # For matching Fact on a page
  field :passage,         :type => String   # Passage for matching: not implemented
  field :content,         :type => String   # Source content
  field :url,             :type => String 
    # Source url

  belongs_to  :site       # The site on which the factlink should be shown

  belongs_to  :created_by,
    :class_name => "User"

  scope :with_site_as_parent, where( :_id.in => Site.all.map { |s| s.facts.map { |f| f.id } }.flatten )

  value :added_to_factlink

  # TODO: Find another way to retrieve all factlinks that have a relation to a site
  # scope :with_site, where( :site.ne => nil ) # is not working.
  # def self.with_site_as_parent
  #   # Map all site, and all factlinks in this site.
  #   factlink_ids = Site.all.map { |s| s.facts.map { |f| f.id } }.flatten
  #   self.where( :_id.in => factlink_ids )
  # end



  def to_s
    self.displaystring
  end
  
  # Return a nice looking url, only subdomain + domain + top level domain
  def pretty_url
    begin
      self.site.url.gsub(/http(s?):\/\//,'').split('/')[0]
    rescue
      self.url.gsub(/http(s?):\/\//,'').split('/')[0]
    end
  end
  
  def set_added_to_factlink(user)
    self.added_to_factlink.value = user.id
  end
  
  def delete_added_to_factlink()
    self.added_to_factlink.delete
  end

  def toggle_opinion(type, user)

    if user.opinion_on_fact_for_type?(type, self)
      # User has this opinion already; remove opinion
      remove_opinions(user)
    else
      # User has none or other opinion, set this one!
      add_opinion(type, user)
    end
  end

  def add_opinion(type, user)
    # Remove the old opinions
    remove_opinions(user)

    # Add user to believers of this Fact
    $redis.zadd(self.redis_key(type), user.authority, user.id)

    # Add the belief type to user
    user.update_opinion(type, self)
  end

  def remove_opinions(user)
    user.remove_opinions(self)
    [:beliefs, :doubts, :disbeliefs].each do |type|
      $redis.zrem(self.redis_key(type), user.id)
    end
  end


  def opiniated_ids(type)
    $redis.zrange(self.redis_key(type), 0, -1)
  end
  
  def opiniated_count(type)
    opiniated_ids(type).count
  end
  
  def opiniated(type)
    User.where(:_id.in => self.opiniated_ids(type))
  end
  
  # All interacting users on this Fact
  def interacting_user_ids
    tmp_key = "factlink:#{self.id}:interacting_users:tmp"
  
    $redis.zunionstore(tmp_key,
                  [self.redis_key(:beliefs), 
                  self.redis_key(:doubts), 
                  self.redis_key(:disbeliefs)])
    
    $redis.zrange(tmp_key, 0, -1)
  end
  
  def interacting_user_count
    self.interacting_user_ids.count
  end
  
  def interacting_users
    User.where(:_id.in => self.interacting_user_ids)
  end


  protected
    # Helper method to generate redis keys
  def redis_key(str)
    "fact:#{self.id}:#{str}"
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
