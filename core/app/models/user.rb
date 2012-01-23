require 'open-uri'
require 'digest/md5'

class User
  include Mongoid::Document
  include Sunspot::Mongoid

  field :name
  field :username
  index :username
  field :twitter
  field :graph_user_id

  field :admin,       type: Boolean, default: false
  field :agrees_tos,  type: Boolean, default: false

  field :seen_the_tour,  type: Boolean, default: false

  attr_protected :admin

  # Only allow letters, digits and underscore in a username
  validates_format_of     :username, :with => /^[A-Za-z0-9\d_]+$/
  validates_presence_of   :username, :message => "is required", :allow_blank => true
  validates_uniqueness_of :username, :message => "must be unique"


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable,
  devise :database_authenticatable,
  :recoverable,   # Password retrieval
  :rememberable,  # 'Remember me' box
  :trackable,     # Log sign in count, timestamps and IP address
  :validatable,   # Validation of email and password
  :confirmable   # Require e-mail verification
  # :registerable   # Allow registration

  searchable :auto_index => true do
    text    :username, :twitter
    string  :username, :twitter
  end

  def graph_user
    @graph_user ||= GraphUser[graph_user_id]
  end

  def graph_user=(guser)
    @graph_user = nil
    self.graph_user_id = guser.id
  end

  def create_graph_user
    guser = GraphUser.new
    guser.save
    self.graph_user = guser

    yield

    guser.user = self
    guser.save
  end

  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end

  def sign_tos(agrees_tos,name)
    valid = true
    unless agrees_tos
      valid = false
      self.errors.add("", "You have to accept the Terms of Service to continue.")
    end
    if name.blank?
      valid = false
      self.errors.add("", "Please fill in your name to accept the Terms of Service.")
    end

    valid and self.update_without_password(agrees_tos: agrees_tos, name: name)
  end

  private :create_graph_user #WARING!!! is called by the database reset function to recreate graph_users after they were wiped, while users were preserved
  around_create :create_graph_user

  def to_s
    username
  end

  def to_param
    username
  end

  def serializable_hash(options={})
    options ||= {}
    options[:except] ||= Array.new
    options[:except] += [
      :admin, :agrees_tos, :'confirmation_sent_at', :confirmation_token,
      :confirmed_at, :current_sign_in_at, :current_sign_in_ip, :encrypted_password,
      :last_sign_in_at, :last_sign_in_ip, :remember_created_at, :reset_password_token,
      :sign_in_count
    ]
    super(options)
  end

  def self.from_param(param)
    self.first :conditions => { username: param }
  end

  def self.find(param,*args)
    super
  rescue
    from_param(param)
  end

  def avatar_url(options={})
    options[:default] ||= :retro
    options[:rating] ||= :PG
    gravatar_url(email,options)
  end

  private
    # from: http://douglasfshearer.com/blog/gravatar-for-ruby-and-ruby-on-rails
    # Returns a Gravatar URL associated with the email parameter.
    #
    # Gravatar Options:
    # - rating: Can be one of G, PG, R or X. Default is X.
    # - size: Size of the image. Default is 80px.
    # - default: URL for fallback image if none is found or image exceeds rating.
    def gravatar_url(email,gravatar_options={})
      grav_url = 'https://secure.gravatar.com/avatar/'
      grav_url << "#{Digest::MD5.new.update(email)}?"
      grav_url << (gravatar_options.slice(:rating,:size,:default).map{|k,v| "#{k}=#{v}"}.join "&")
      grav_url
    end

end
