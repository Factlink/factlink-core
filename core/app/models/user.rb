class User
  include Mongoid::Document

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

  has_many :factlinks, :as => :created_by

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
  

  def update_opinion(type, factlink, parent)
    # Remove existing opinion by user
    remove_opinions(factlink, parent)

    # Adds the factlink_id to the active factlinks of the user
    add_active_factlink(factlink)
    
    key = redis_factlink_opinion_key(parent)    

    $redis.hset(key, factlink.id, opinion_id(type))
    
    # Adds the factlink_id to the users correct set
    $redis.sadd(self.redis_key(type), factlink.id)
  end
  
  def opinion_id(type)
    foo = {
      'beliefs' => 0,
      'doubts' => 1,
      'disbeliefs' => 2,
    }
    foo[type]
  end
  
  def inverse_opinion_hash(the_id)
    foo = {
      0 => 'beliefs',
      1 => 'doubts',
      2 => 'disbeliefs',
    }
    foo[the_id.to_i]
  end
  
  def get_opinion(factlink, parent)
    key = redis_factlink_opinion_key(parent)
    $redis.hget(key, factlink.id)
  end

  def remove_opinions(factlink, parent)
    remove_active_factlink factlink

    key = redis_factlink_opinion_key(parent)
    # Remove the believe||doubt||disbelieve hash
    $redis.hdel(key, factlink.id)

    # Remove this factlink id from the belief||doubt||disbelief set
    [:beliefs, :doubts, :disbeliefs].each do |type|
      $redis.srem(self.redis_key(type), factlink.id)
    end
  end
  
  def believes_factlink?(factlink)
    $redis.sismember(self.redis_key(:beliefs), factlink.id)
  end
  
  def opinion_on_factlink?(type, factlink)
    $redis.sismember(self.redis_key(type), factlink.id)
  end

  def opinion_class(type, factlink, parent)
    # Key to the User hash of factlink opinions
    key = self.redis_factlink_opinion_key(parent)

    # hash can be:
    # 0   => beliefs
    # 1   => doubts
    # 2   => disbeliefs
    # nil => no opinion
    hash = $redis.hget(key, factlink.id)
    
    if hash
      
      if inverse_opinion_hash(hash) == type.to_s
        puts "Returning active"
        return "active"
      else
        puts "returning nothing"
        return ""
      end
    else
      puts "No Hash"
      return ""
    end
    
      
    # if opinion_on_factlink?(type, factlink)
    #   return "active"
    # else
    #   return ""
    # end
    
  end
  
  
  # Believe
  def believe_ids
    $redis.smembers(self.redis_key(:beliefs))
  end

  def believe_count
    $redis.scard(self.redis_key(:beliefs))
  end
  
  def believed_facts
    Factlink.where(:_id.in => self.believe_ids)
  end


  # Doubt
  def doubt_ids
    $redis.smembers(self.redis_key(:doubts))
  end
  
  def doubt_count
    $redis.scard(self.redis_key(:doubts))
  end  
  
  def doubted_facts
    Factlink.where(:_id.in => self.doubt_ids)
  end
  
  # Disbelieve
  def disbelieve_ids
    $redis.smembers(self.redis_key(:disbeliefs))
  end
  
  def disbelieve_count
    $redis.scard(self.redis_key(:disbeliefs))
  end
  
  def disbelieved_facts
    Factlink.where(:_id.in => self.disbelieve_ids)
  end



  # Ids of the Factlinks the user interacted with
  def active_on_factlinks    
    $redis.sunion(self.redis_key(:beliefs), 
                  self.redis_key(:doubts), 
                  self.redis_key(:disbeliefs))
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

  
  
  
  def clear_redis
    
    
    
  end
  
  # # # New # # #
  protected
  # Helper method to generate redis keys
  def redis_key(str)
    "user:#{self.id}:#{str}"
  end

  def redis_factlink_opinion_key factlink
    # becomes: "user:userid:factlink:factlink_id"
    self.redis_key("factlink:#{factlink.id}")
  end

end