class Factlink
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid

  searchable :auto_index => true do
    text    :displaystring
    string  :displaystring
    time    :created_at
  end

  field :title,           :type => String
  field :displaystring,   :type => String   # For matching Factlink on a page
  field :passage,         :type => String   # Passage for matching: not implemented
  field :content,         :type => String   # Source content
  field :url,             :type => String   # Source url

  # Linking of factlinks
  has_and_belongs_to_many :parents,
    :class_name => self.name

  has_and_belongs_to_many :childs,
    :class_name => self.name

  belongs_to  :site       # The site on which the factlink should be shown

  belongs_to  :created_by,
    :class_name => "User"


  scope :with_site_as_parent, where( :_id.in => Site.all.map { |s| s.factlinks.map { |f| f.id } }.flatten )

  # TODO: Find another way to retrieve all factlinks that have a relation to a site
  # scope :with_site, where( :site.ne => nil ) # is not working.
  # def self.with_site_as_parent
  #   # Map all site, and all factlinks in this site.
  #   factlink_ids = Site.all.map { |s| s.factlinks.map { |f| f.id } }.flatten
  #   self.where( :_id.in => factlink_ids )
  # end



  def to_s
    self.displaystring
  end

  # TODO: Refactor to regular .count method where needed.
  #
  # Know bug in Mongoid, count on a habtm relation does not work.
  # https://github.com/mongoid/mongoid/issues/893
  #
  # Temporary workaround:
  def parents_count
    self.parents.to_a.count
  end
  # See comment above
  def childs_count
    self.childs.to_a.count
  end

  def set_parent parent_id
    parent = Factlink.find(parent_id)
    parent.childs << self
  end

  # Add a child node
  def add_child(child, user)
    self.childs << child
    
    # Store who added this Factlink
    child.set_added_to_factlink(self, user)
  end

  def set_added_to_factlink(factlink, user)
    # Redis     Key................., Field......, Value..
    $redis.hset(redis_key(:added_to), factlink.id, user.id)
  end
  
  def delete_added_to_factlink(factlink)
    # Redis     Key................., Field......, Value..
    $redis.hdel(redis_key(:added_to), factlink.id)
  end

  def add_child_as_supporting(factlink, user)
    # Add the Mongo reference
    self.add_child(factlink, user)

    # Store supporting factlink ID in supporting factlinks set
    $redis.sadd(redis_key(:supporting_facts), factlink.id)
  end

  def add_child_as_weakening(factlink, user)
    # Add the Mongo reference
    self.add_child(factlink, user)

    # Store supporting factlink ID in supporting factlinks set
    $redis.sadd(redis_key(:weakening_facts), factlink.id)
  end


  # Remove a child node
  def remove_child(child)
    self.childs.delete child  # Remove the child
    child.remove_parent(self) # Remove child from parent
    
    # Remove the factlink_id from supporting/weakning facts set 
    $redis.srem(redis_key(:supporting_facts), child.id)
    $redis.srem(redis_key(:weakening_facts), child.id)
    
    child.delete_added_to_factlink(self)
  end

  
  def added_to_parent_by_current_user(parent, user)
    user_id = $redis.hget("factlink:#{self.id}:added_to", parent.id)    
    user_id == user.id.to_s # Don't compare BSON::ObjectId, just compare the string.
  end

  def remove_parent(parent)
    self.parents.delete parent
    self.save
  end

  def supporting_fact_ids
    $redis.smembers(redis_key(:supporting_facts))
  end

  def weakening_fact_ids
    $redis.smembers(redis_key(:weakening_facts))
  end
  
  def supported_by?(factlink)
    $redis.sismember(redis_key(:supporting_facts), factlink.id.to_s)
  end

  def weakened_by?(factlink)
    $redis.sismember(redis_key(:weakening_facts), factlink.id.to_s)
  end


  def belief_total
    self.childs.map { |child| child.believer_count }.inject(1) { |result, value | result + value }
  end

  def doubt_total
    self.childs.map { |child| child.doubter_count }.inject(1) { |result, value | result + value }
  end

  def disbelieve_total
    self.childs.map { |child| child.disbeliever_count }.inject(1) { |result, value | result + value }
  end


  def set_opinion(user, type, parent)

    if user.opinion_on_factlink?(type, self)
      # User has this opinion already; remove opinion
      remove_opinions(user, parent)
    else
      # User has none or other opinion, set this one!
      add_opinion(type, user, parent)
    end
  end

  def add_opinion(type, user, parent)
    # Remove the old opinions
    remove_opinions(user, parent)

    # Add user to believers of this Factlink
    $redis.zadd(self.redis_key(type), user.authority, user.id)

    # Add the belief type to user
    user.update_opinion(type, self, parent)
  end

  def remove_opinions(user, parent)
    user.remove_opinions(self, parent)
    [:beliefs, :doubts, :disbeliefs].each do |type|
      $redis.zrem(self.redis_key(type), user.id)
    end
  end


  ##########
  # Believers
  # believer_ids are stored in Redis, using the self.redis_key(:beliefs)

  # Return all believers
  def believers
    return User.where(:_id.in => self.believer_ids)
  end

  # Return all believer ids
  def believer_ids
    $redis.zrange(self.redis_key(:beliefs), 0, -1) # Ranges all items
  end

  # Count all believers
  def believer_count
    $redis.zcard(self.redis_key(:beliefs))
  end

  def add_believer(user, parent)
    add_opinion(:beliefs,user, parent)
  end



  ##########
  # Doubters
  # doubter_ids are stored in Redis, using the self.redis_key(:doubts)

  # Return all doubters
  def doubters
    return User.where(:_id.in => self.doubter_ids)
  end

  # Return all believer ids
  def doubter_ids
    $redis.zrange(self.redis_key(:doubts), 0, -1) # Ranges all items
  end

  # Count all doubters
  def doubter_count
    $redis.zcard(self.redis_key(:doubts))
  end

  def add_doubter(user, parent)
    add_opinion(:doubts, user, parent)
  end


  ##########
  # Disbelievers
  # disbeliever_ids are stored in Redis, using the self.redis_key(:disbeliefs)

  # Return all believers
  def disbelievers
    return User.where(:_id.in => self.disbeliever_ids)
  end

  # Return all disbeliever ids
  def disbeliever_ids
    $redis.zrange(self.redis_key(:disbeliefs), 0, -1) # Ranges all items
  end

  # Count all disbelievers
  def disbeliever_count
    $redis.zcard(self.redis_key(:disbeliefs))
  end

  def add_disbeliever(user, parent)
    add_opinion(:disbeliefs, user, parent)
  end

  
  # All interacting users on this Factlink
  def interacting_user_ids
    tmp_key = "factlink:#{self.id}:interacting_users:tmp"
  
    $redis.zunionstore(tmp_key,
                  [self.redis_key(:beliefs), 
                  self.redis_key(:disbeliefs), 
                  self.redis_key(:disbeliefs)])
    
    $redis.zrange(tmp_key, 0, -1)
  end
  
  def interacting_user_count
    self.interacting_user_ids.count
  end
  
  def interacting_users
    User.where(:_id.in => self.interacting_user_ids)
  end


  # SCORE STUFF
  # TODO: Needs some refactoring and new calculations
  def score_dict_as_percentage
    total = total_score

    percentage_score_dict = {
      :believe {
        :percentage => percentage(total, belief_total),
        :authority => 0.65
      },
      :doubt {
        :percentage => percentage(total, doubt_total),
        :authority => 0.20
      },
      :disbelieve {
        :percentage => percentage(total, disbelieve_total),
        :authority => 0.15
      }
    }
    percentage_score_dict
  end

  def score_dict_as_absolute
    # TODO: Calculate values in stead of dummy data
    absolute_score_dict = {
      :proves => disbelieve_total,
      :maybe => doubt_total,
      :denies => belief_total
    }
    absolute_score_dict
  end

  def total_score
    # TODO: Should be called total_activity ?
    sum = self.belief_total +
      self.doubt_total  +
      self.disbelieve_total

    # Quick hack against divide by zero
    if sum == 0
      sum = 1
    end

    sum
  end

  # Percentual scores
  def percentage_score_denies
    score_dict_as_percentage[:denies]
  end

  def percentage_score_maybe
    score_dict_as_percentage[:maybe]
  end

  def percentage_score_proves
    score_dict_as_percentage[:proves]
  end


  # Relevance of a supporting or weakening fact
  # 
  # [:relevant, :might_be_relevant, :not_relevant]
  # :might_be_relevant
  # :not_relevant
  # 
  # Key
  # factlink:relevance:#{factlink_id}:#{child_id}:[:relevant||:might_be_relevant||:not_relevant]
  #

  # Gets the count of users of the relevance type of the child
  def get_relevant_users_count_for_child_and_type(child, type)
    key = redis_relevance_key(child, type)
    $redis.zcard(key)
  end
  
  # Gets all user ids for the relevance type on this child
  def get_relevant_users_for_child_and_type(child, type)
    key = redis_relevance_key(child, type)
    $redis.zrange(key, 0, -1) # Returns all user ids
  end
  
  # Sets or toggles the relevance by the user on the child with this type
  def set_relevance_for_user(child, type, user)

    if user_has_relevance_on_child?(child, type, user)
      # User has this relevance type set already; remove relevance
      remove_relevance_for_user(child, user)
    else
      # User has none or other opinion
      # Clears the current opinion, and adds the new opinion.
      add_relevance_for_user(child, type, user)
    end

  end

  def user_has_relevance_on_child?(child, type, user)
    key = redis_relevance_key(child, type)
    
    # If rank gets returned, the user has this opinion.
    if $redis.zrank(key, user.id)
      return true
    else
      return false
    end
  end

  # Adds relevance opinion of the user on the child.
  def add_relevance_for_user(child, type, user)
    # Remove the old relevances set by this user
    remove_relevance_for_user(child, user)
    
    key = redis_relevance_key(child, type)
    $redis.zadd(key, user.authority, user.id)
  end

  # Remove the relevance set by this user. 
  def remove_relevance_for_user(child, user)
    [:relevant, :might_be_relevant, :not_relevant].each do |type|
      $redis.zrem(redis_relevance_key(child, type), user.id)
    end
  end

  def relevance_class(child, type, user)
    # Used to show the relevance of a child to a parent.
    if user_has_relevance_on_child?(child, type, user)
      return "active"
    else
      return ""
    end
  end

  # Stats count
  def stats_count
    # Fancy score calculation
    (10 * belief_total) + (10 * doubt_total) - (10 * disbelieve_total)
  end

  # Used for sorting
  def self.column_names
    self.fields.collect { |field| field[0] }
  end


  protected
    # Helper method to generate redis keys
  def redis_key(str)
    "factlink:#{self.id}:#{str}"
  end
  
  def redis_relevance_key(child, type)    
    "factlink:relevance:#{self.id}:#{child.id}:#{type}"
  end

  def percentage(total, part)
    if total > 0
      (100 * part) / total
    else
      0
    end
  end


end
