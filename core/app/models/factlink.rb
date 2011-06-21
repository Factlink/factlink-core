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

    puts "Adding: #{self.redis_key(type)}"
    
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
    add_opinion(:disbeliefs,user, parent)
  end


  # SCORE STUFF
  # TODO: Needs some refactoring and new calculations
  def score_dict_as_percentage
    total = total_score

    percentage_score_dict = {
      :proves => percentage(total, belief_total),
      :maybe => percentage(total, doubt_total),
      :denies => percentage(total, disbelieve_total)
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
  
  def percentage(total, part)
    if total > 0
      (100 * part) / total
    else
      0
    end
  end
  

end