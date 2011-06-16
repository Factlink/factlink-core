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
  

  # Believe
  def belief_ids
    $redis.smembers(self.redis_believes_key)
  end
  
  def belief_count
    $redis.scard(self.redis_believes_key)
  end
  
  def add_believe factlink
    # Remove existing opinion by user
    remove_doubt factlink
    remove_disbelieve factlink
    $redis.sadd(self.redis_believes_key, factlink.id)
  end
  
  def remove_believe factlink
    $redis.srem(self.redis_believes_key, factlink.id)
  end

  # Doubt
  def doubt_ids
    $redis.smembers(self.redis_doubts_key)
  end
  
  def doubt_count
    $redis.scard(self.redis_doubts_key)
  end
  
  def add_doubt factlink
    # Remove existing opinion by user
    remove_believe factlink
    remove_disbelieve factlink
    $redis.sadd(self.redis_doubts_key, factlink.id)
  end
  
  def remove_doubt factlink
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
    # Remove existing opinion by user
    remove_believe factlink
    remove_doubt factlink
    $redis.sadd(self.redis_disbelieves_key, factlink.id)
  end
  
  def remove_disbelieve factlink
    $redis.srem(self.redis_disbelieves_key, factlink.id)
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