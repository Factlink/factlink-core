module GraphUserProxy
  deprecate
  def facts
    graph_user.facts
  end
  
  deprecate
  def remove_opinions(*args)
    graph_user.remove_opinions(*args)
  end
  
  deprecate
  def update_opinion(*args)
    graph_user.update_opinion(*args)
  end
  
  deprecate
  def opinion_on_fact_for_type?(*args)
    graph_user.has_opinion?(*args)
  end
end

class User
  include Mongoid::Document
  include GraphUserProxy

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

  field :graph_user_id
  def graph_user
    if graph_user_id
      return GraphUser[graph_user_id]
    else
      graphuser = GraphUser.new
      graphuser.save
      graph_user_id = graphuser.id
      save
      graphuser.user = self
      graphuser.save
      return graphuser
    end
  end

  def graph_user=(guser)
    graph_user_id=guser.id
    save
  end

  validates_presence_of :username, :message => "is required", :allow_blank => true
  validates_uniqueness_of :username, :message => "must be unique"
  # Only allow letters, digits and underscore in a username
  validates_format_of :username, :with => /^[A-Za-z0-9\d_]+$/

  def to_s
    username
  end




end
