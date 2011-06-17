class User
  include Mongoid::Document
  include Mongo::Voter

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable, :registerable,
  devise  :database_authenticatable, 
          :recoverable,   # Password retrieval
          :rememberable,  # 'Remember me' box
          :trackable,     # Log sign in count, timestamps and IP address
          :validatable,   # Validation of email and password
          :confirmable,   # Require e-mail verification
          :registerable   # Allow registration

  field :username
  # field :first_name
  # field :last_name

  has_many :factlink_tops, :as => :created_by
  has_many :factlink_subs, :as => :created_by

  validates_presence_of :username, :message => "is required", :allow_blank => true
  validates_uniqueness_of :username, :message => "must be unique"
  # Only allow letters, digits and underscore in a username
  validates_format_of :username, :with => /^[A-Za-z0-9\d_]+$/
  # validates_uniqueness_of :email, :message => "must be unique"
  
  def to_s
    username
  end
  
  # Authority of the user
  def authority
    0.481
  end
  
  ##########
  # Believe
  #
  # Return all factlink_ids this user believes
  def believe_ids
    $redis.smembers(self.redis_believes_key)
  end

  def believe_count
    $redis.scard(self.redis_believes_key)
  end
  
  def add_believe factlink
    add_active_factlink factlink
    
    # Remove existing opinion by user
    remove_doubt factlink
    remove_disbelieve factlink
    $redis.sadd(self.redis_believes_key, factlink.id)
  end
  
  def remove_believe factlink
    remove_active_factlink factlink
    $redis.srem(self.redis_believes_key, factlink.id)
  end

  def believes_factlink?(factlink)
    $redis.sismember(self.redis_believes_key, factlink.id)
  end

  # Doubt
  def doubt_ids
    $redis.smembers(self.redis_doubts_key)
  end
  
  def doubt_count
    $redis.scard(self.redis_doubts_key)
  end
  
  def add_doubt factlink
    add_active_factlink factlink
    
    # Remove existing opinion by user
    remove_believe factlink
    remove_disbelieve factlink
    $redis.sadd(self.redis_doubts_key, factlink.id)
  end
  
  def remove_doubt factlink
    remove_active_factlink factlink
    $redis.srem(self.redis_doubts_key, factlink.id)
  end
  
  # Disbelieve
  def disbelieve_ids
    $redis.smembers(self.redis_disbelieves_key)
  end
  
  def disbelieve_count
    $redis.scard(self.redis_disbelieves_key)
  end
  
  def add_disbelieve factlink
    add_active_factlink factlink
    
    # Remove existing opinion by user
    remove_believe factlink
    remove_doubt factlink
    $redis.sadd(self.redis_disbelieves_key, factlink.id)
  end
  
  def remove_disbelieve factlink
    remove_active_factlink factlink
    $redis.srem(self.redis_disbelieves_key, factlink.id)
  end
  
  
  # ids of the Factlinks the user interacted with
  def active_on_factlinks    
    $redis.sunion(self.redis_believes_key, 
                  self.redis_doubts_key, 
                  self.redis_disbelieves_key)
  end
  
  # Add factlink_id to the users active factlinks
  def add_active_factlink factlink
    key = self.redis_key(:active_factlinks)
    $redis.sadd(key, factlink.id)
  end
  
  # Remove factlink_id from the users active factlinks
  def remove_active_factlink factlink
    key = self.redis_key(:active_factlinks)
    $redis.srem(key, factlink.id)
  end

  
  def add_opinion(factlink, parent)
    key = redis_factlink_opinion_key(parent)
    puts "adding: key: #{key}\nid: #{factlink.id}\nval: 1337"
    $redis.hset(key, factlink.id, 1337)
  end
  
  def get_opinion(factlink, parent)
    key = redis_factlink_opinion_key(parent)
    puts "getting: key: #{key}\nid: #{factlink.id}"
    
    puts "\n\nGot: #{$redis.hget(key, factlink.id)}"
    
    $redis.hget(key, factlink.id)
  end
  
  ### Teh old Factlinkzz ###
  
  # Voted objects
  def up_voted_sources
    FactlinkSub.up_voted_by(self)
  end
  
  def down_voted_sources
    FactlinkSub.down_voted_by(self)
  end
  
  def voted_source
    FactlinkSub.voted_by(self)
  end

  # Vote counts
  def up_voted_sources_count
    FactlinkSub.up_voted_by(self).count
  end
  
  def down_voted_sources_count
    FactlinkSub.down_voted_by(self).count
  end
  
  def voted_source_count
    FactlinkSub.voted_by(self).count
  end





  # # # New # # #
  protected
  # Helper method to generate redis keys
  def redis_key(str)
    "user:#{self.id}:#{str}"
  end


  def redis_factlink_opinion_key factlink
    self.redis_key("factlink:#{factlink.id}")
  end

  def redis_believes_key
    self.redis_key(:beliefs)
  end
  
  def redis_doubts_key
    self.redis_key(:doubts)
  end
  
  def redis_disbelieves_key
    self.redis_key(:disbeliefs)
  end

end