class User
  include Mongoid::Document

  # Several key components of the user are stored in Redis.
  #
  # redis_key(:beliefs||:doubts||:disbeliefs) store the Fact ID's the \
  # user interacted with.
  #

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable, 
  devise :database_authenticatable,
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

  def to_s
    username
  end

  # Authority of the user
  def authority
    0.481
  end


  def update_opinion(type, fact)
    # Remove existing opinion by user
    remove_opinions(fact)

    # Adds the factlink_id to the active factlinks of the user
    add_active_factlink(fact)

    key = redis_factlink_opinion_key()
    $redis.hset(key, fact.id, opinion_id(type))

    # Adds the factlink_id to the users correct set
    $redis.sadd(self.redis_key(type), fact.id)
  end

  def opinion_id(type)
    foo = {
      'beliefs'     => 0,
      'doubts'      => 1,
      'disbeliefs'  => 2,
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

  def get_opinion(fact)
    key = redis_factlink_opinion_key
    $redis.hget(key, fact.id)
  end

  def remove_opinions(factlink)
    remove_active_factlink factlink

    key = redis_factlink_opinion_key()
    # Remove the believe||doubt||disbelieve hash
    $redis.hdel(key, factlink.id)

    # Remove this factlink id from the belief||doubt||disbelief set
    [:beliefs, :doubts, :disbeliefs].each do |type|
      $redis.srem(self.redis_key(type), factlink.id)
    end
  end

  def opinion_on_fact_for_type(type, fact)
    if $redis.sismember(self.redis_key(type), fact.id.to_s)
      return 'active'
    else
      return ''
    end
  end

  def opinion_class(type, factlink, parent)
    # Used to show the opinion of a user on a fact.
    # Checks if the factlink id is stored in one of the believe types of this
    # user. 
    if $redis.sismember(self.redis_key(type), factlink.id.to_s)
      return "active"
    else
      return ""
    end  
  end


  # Believe
  deprecate
  def believe_ids
    $redis.smembers(self.redis_key(:beliefs))
  end

  deprecate
  def believe_count
    $redis.scard(self.redis_key(:beliefs))
  end

  deprecate
  def believed_facts
    Fact.where(:_id.in => self.believe_ids)
  end


  # Doubt
  deprecate
  def doubt_ids
    $redis.smembers(self.redis_key(:doubts))
  end

  deprecate
  def doubt_count
    $redis.scard(self.redis_key(:doubts))
  end

  deprecate
  def doubted_facts
    Fact.where(:_id.in => self.doubt_ids)
  end

  # Disbelieve
  deprecate
  def disbelieve_ids
    $redis.smembers(self.redis_key(:disbeliefs))
  end

  deprecate
  def disbelieve_count
    $redis.scard(self.redis_key(:disbeliefs))
  end

  deprecate
  def disbelieved_facts
    Fact.where(:_id.in => self.disbelieve_ids)
  end



  # Ids of the Facts the user interacted with
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


  

  protected
    # Helper method to generate redis keys
    def redis_key(str)
      "user:#{self.id}:#{str}"
    end

    def redis_factlink_opinion_key
      # becomes: "user:userid:factlink:factlink_id"
      self.redis_key("factlink:foobar:")
    end

end
