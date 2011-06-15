class Factlink
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,         :type => String
  field :displaystring, :type => String
  field :description,   :type => String
  field :text,          :type => String
  field :content,       :type => String

  # Redis is used for storing the belief, doubt and disbeliefs
  
  validates_presence_of :title
    
  has_and_belongs_to_many :parents,
                          :class_name => self.name

  has_and_belongs_to_many :childs,
                          :class_name => self.name


  def to_s
    self.displaystring
  end

  # Just for testing rspec
  def arrz
    ["123", "456"]
  end


  ##########
  # Believers
  # believer_ids are stored in Redis, using the self.redis_believers_key
  
  # Return all believers
  def believers
    return User.where(:_id.in => self.believers_ids)
  end
  
  # Return all believer ids
  def believers_ids
    $redis.zrange(self.redis_believers_key, 0, -1) # Ranges all items
  end

  # Count all believers
  def believers_count
    $redis.zcard(self.redis_believers_key)
  end

  def add_believer user
    # Add the believe to user
    user.add_believe self
    
    # Add user to believers of this Factlink
    remove_doubter user     # Remove from other sets
    remove_disbeliever user # Remove from other sets
    $redis.zadd(self.redis_believers_key, user.authority, user.id)
  end
  
  def remove_believer user
    $redis.zrem(self.redis_believers_key, user.id)
  end


  ##########
  # Doubters
  # doubter_ids are stored in Redis, using the self.redis_doubters_key
  
  # Return all doubters
  def doubters
    return User.where(:_id.in => self.doubter_ids)
  end
  
  # Return all believer ids
  def doubters_ids
    $redis.zrange(self.redis_doubters_key, 0, -1) # Ranges all items
  end

  # Count all doubters
  def doubters_count
    $redis.zcard(self.redis_doubters_key)
  end

  def add_doubter user
    # Add the doubter to user
    user.add_doubt self
    
    # Add user to doubters of this Factlink
    remove_believer user    # Remove from other sets
    remove_disbeliever user # Remove from other sets
    $redis.zadd(self.redis_doubters_key, user.authority, user.id)
  end
  
  def remove_doubter user
    $redis.zrem(self.redis_doubters_key, user.id)
  end


  ##########
  # Disbelievers
  # disbeliever_ids are stored in Redis, using the self.redis_disbelievers_key
  
  # Return all believers
  def disbelievers
    return User.where(:_id.in => self.disbelievers_ids)
  end
  
  # Return all disbeliever ids
  def disbelievers_ids
    $redis.zrange(self.redis_disbelievers_key, 0, -1) # Ranges all items
  end

  # Count all disbelievers
  def disbelievers_count
    $redis.zcard(self.redis_disbelievers_key)
  end

  def add_disbeliever user
    # Add the disbeliever to user
    user.add_disbelieve self
    
    # Add user to disbelievers of this Factlink
    remove_believer user    # Remove from other sets
    remove_doubter user     # Remove from other sets
    $redis.zadd(self.redis_disbelievers_key, user.authority, user.id)
  end
  
  def remove_disbeliever user
    $redis.zrem(self.redis_disbelievers_key, user.id)
  end


  protected  
  # Helper method to generate redis keys
  def redis_key(str)
    "user:#{self.id}:#{str}"
  end
  
  def redis_believers_key
    # "#{self._id}:believers"
    self.redis_key(:believers)
  end
  
  def redis_doubters_key
    # "#{self._id}:doubters"
    self.redis_key(:doubters)
  end
  
  def redis_disbelievers_key
    # "#{self._id}:disbelievers"
    self.redis_key(:disbelievers)
  end
  
end