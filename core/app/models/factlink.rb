class Factlink
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid
  searchable do
    text :displaystring
  end
  
  field :title,           :type => String
  field :displaystring,   :type => String
  field :description,     :type => String
  field :passage,         :type => String
  field :content,         :type => String
  
  # Linking of factlinks  
  has_and_belongs_to_many :parents,
                          :class_name => self.name

  has_and_belongs_to_many :childs,
                          :class_name => self.name

  belongs_to  :site       # The site on which the factlink should be shown

  belongs_to  :created_by,
              :class_name => "User"

  
  def to_s
    self.displaystring
  end

  # TODO: Refactor to regular .count methond where needed.
  #
  # Know bug in Mongoid, count on a habtm relation does not work.
  # https://github.com/mongoid/mongoid/issues/893
  #
  # Temporary workaround:
  def parents_count
    self.parents.to_a.count
  end
  
  def childs_count
    self.childs.to_a.count
  end


  def belief_total
    self.childs.map { |child| child.believer_count }.inject(0) { |result, value | result + value }
  end

  def doubt_total
    self.childs.map { |child| child.doubter_count }.inject(0) { |result, value | result + value }
  end

  def disbelieve_total
    self.childs.map { |child| child.disbeliever_count }.inject(0) { |result, value | result + value }
  end


  ##########
  # Believers
  # believer_ids are stored in Redis, using the self.redis_key(:believers)
  
  # Return all believers
  def believers
    return User.where(:_id.in => self.believer_ids)
  end
  
  # Return all believer ids
  def believer_ids
    $redis.zrange(self.redis_key(:believers), 0, -1) # Ranges all items
  end

  # Count all believers
  def believer_count
    $redis.zcard(self.redis_key(:believers))
  end

  def add_believer user
    # Add the believe to user
    user.add_believe self
    
    # Add user to believers of this Factlink
    remove_doubter user     # Remove from other sets
    remove_disbeliever user # Remove from other sets
    $redis.zadd(self.redis_key(:believers), user.authority, user.id)
  end
  
  def remove_believer user
    $redis.zrem(self.redis_key(:believers), user.id)
  end


  ##########
  # Doubters
  # doubter_ids are stored in Redis, using the self.redis_key(:doubters)
  
  # Return all doubters
  def doubters
    return User.where(:_id.in => self.doubter_ids)
  end
  
  # Return all believer ids
  def doubter_ids
    $redis.zrange(self.redis_key(:doubters), 0, -1) # Ranges all items
  end

  # Count all doubters
  def doubter_count
    $redis.zcard(self.redis_key(:doubters))
  end

  def add_doubter user
    # Add the doubter to user
    user.add_doubt self
    
    # Add user to doubters of this Factlink
    remove_believer user    # Remove from other sets
    remove_disbeliever user # Remove from other sets
    $redis.zadd(self.redis_key(:doubters), user.authority, user.id)
  end
  
  def remove_doubter user
    $redis.zrem(self.redis_key(:doubters), user.id)
  end


  ##########
  # Disbelievers
  # disbeliever_ids are stored in Redis, using the self.redis_key(:disbelievers)
  
  # Return all believers
  def disbelievers
    return User.where(:_id.in => self.disbeliever_ids)
  end
  
  # Return all disbeliever ids
  def disbeliever_ids
    $redis.zrange(self.redis_key(:disbelievers), 0, -1) # Ranges all items
  end

  # Count all disbelievers
  def disbeliever_count
    $redis.zcard(self.redis_key(:disbelievers))
  end

  def add_disbeliever user
    # Add the disbeliever to user
    user.add_disbelieve self
    
    # Add user to disbelievers of this Factlink
    remove_believer user    # Remove from other sets
    remove_doubter user     # Remove from other sets
    $redis.zadd(self.redis_key(:disbelievers), user.authority, user.id)
  end
  
  def remove_disbeliever user
    $redis.zrem(self.redis_key(:disbelievers), user.id)
  end


  # SCORE STUFF
  # TODO: Needs some refactoring and new calculations
  def score_dict_as_percentage
    # TODO: Calculate values in stead of dummy data
    percentage_score_dict = {}

    percentage_score_dict['denies'] = 14
    percentage_score_dict['maybe'] = 32
    percentage_score_dict['proves'] = 54

    percentage_score_dict
  end

  def score_dict_as_absolute
    # TODO: Calculate values in stead of dummy data
    absolute_score_dict = {}

    absolute_score_dict['denies'] = 7
    absolute_score_dict['maybe'] = 16
    absolute_score_dict['proves'] = 27

    absolute_score_dict
  end

  def total_score
    # TODO: Should be called total_activity ?

    # [self.score_denies, self.score_maybe, self.score_proves].inject(1) { | result, value | result + value }
    sum = self.believer_count + 
          self.doubter_count  + 
          self.disbeliever_count
    
    # Quick hack against divide by zero
    if sum == 0
      sum = 1
    end
    
    sum
  end

  # Percentual scores
  def percentage_score_denies
    score_dict_as_percentage['denies']
  end
  
  def percentage_score_maybe
    score_dict_as_percentage['maybe']
  end
  
  def percentage_score_proves
    score_dict_as_percentage['proves']
  end

  # Absolute scores
  def absolute_score_denies
    self.score_denies
  end
  
  def absolute_score_maybe
    self.score_maybe
  end
  
  def absolute_score_proves
    self.score_proves
  end
  
  # Stats count
  def stats_count
    # Fancy score calculation
    (10 * absolute_score_proves) + (1 * absolute_score_maybe) - (10 * absolute_score_denies)
  end



  protected  
  # Helper method to generate redis keys
  def redis_key(str)
    "factlink:#{self.id}:#{str}"
  end
  
end