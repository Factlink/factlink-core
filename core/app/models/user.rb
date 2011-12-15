require 'open-uri'

class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Sunspot::Mongoid

  field :username
  index :username
  field :twitter
  field :graph_user_id

  field :admin, type: Boolean, default: false
  field :agrees_tos, type: Boolean, default: false
  
  attr_protected :admin, :agrees_tos

  # Only allow letters, digits and underscore in a username
  validates_format_of :username, :with => /^[A-Za-z0-9\d_]+$/
  validates_presence_of :username, :message => "is required", :allow_blank => true
  validates_uniqueness_of :username, :message => "must be unique"

  has_mongoid_attached_file :avatar,
    :default_url   => "/images/avatar.jpeg",
    :styles => {
      :small  => "32x32#",
      :medium => "48x48#",
      :large  => "64x64#"
    }
  before_post_process :set_avatar_filename
  
  after_create :set_avatar_from_twitter
  
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

  private :create_graph_user #WARING!!! is called by the database reset function to recreate graph_users after they were wiped, while users were preserved
  around_create :create_graph_user

  def to_s
    username
  end


  def set_avatar_from_twitter
    if self.twitter
      url = twitter_image_url

      begin
        self.avatar = open(url)
        self.save
      rescue
        puts "[Error] Failed twitter_image_url - User#set_avatar_from_twitter"
      end
    end
  end

  private
  def update_avatar
    unless self.avatar_updated_at
      set_avatar_filename
    end
  end
  
  def set_avatar_filename
    self.avatar.instance_write(:file_name, self.twitter)
  end
  
  def twitter_image_url
    "http://api.twitter.com/1/users/profile_image?screen_name=#{twitter}&size=bigger"
  end

end
