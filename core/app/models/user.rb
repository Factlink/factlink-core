module GraphUserProxy
  include Canivete::Deprecate


  deprecate
  # this is the list of facts the user created
  def facts
    fl = Fact.find(:created_by => graph_user) || []
    fl.find_all {|fact| fact.class != FactRelation }
  end
  
  def fact_relations
    FactRelation.find(:created_by => graph_user) || []
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
  
  deprecate 
  def believe_count
    graph_user.facts_he(:beliefs).size
  end
  deprecate 
  def doubt_count
    graph_user.facts_he(:doubts).size
  end
  deprecate 
  def disbelieve_count
    graph_user.facts_he(:disbeliefs).size
  end
  
  deprecate
  def believed_facts
    graph_user.facts_he(:beliefs)
  end
  
  deprecate
  def doubted_facts
    graph_user.facts_he(:doubts)
  end
  
  deprecate
  def disbelieved_facts
    graph_user.facts_he(:disbeliefs)
  end
end

class User
  include Mongoid::Document
  include GraphUserProxy

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
  field :graph_user_id

  # Only allow letters, digits and underscore in a username
  validates_format_of :username, :with => /^[A-Za-z0-9\d_]+$/
  validates_presence_of :username, :message => "is required", :allow_blank => true
  validates_uniqueness_of :username, :message => "must be unique"

  def graph_user
    if graph_user_id
      return GraphUser[graph_user_id]
    else
      guser = GraphUser.new
      guser.save

      self.graph_user = guser

      guser.user = self
      guser.save
      return guser
    end
  end

  def graph_user=(guser)
    self.graph_user_id = guser.id
    self.save
  end

  def to_s
    username
  end

end
