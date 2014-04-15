require 'open-uri'
require 'digest/md5'
require 'redis/objects'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Redis::Objects

  # For compatibility with Activity::Listener
  def self.[](graph_user_id)
    User.where(graph_user_id: graph_user_id).first
  end

  field :notification_settings_edit_token, type: String

  USERNAME_MAX_LENGTH = 20 # WARNING: must be shorter than mongo ids(24 chars) to avoid confusing ids with usernames!

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  field :username
  field :full_name    # TODO:EMN minimum length?  require space?

  index(username: 1)

  field :registration_code

  field :location
  field :biography

  field :graph_user_id
  index(graph_user_id: 1)

  field :deleted,     type: Boolean, default: false

  field :admin,       type: Boolean, default: false

  field :receives_mailed_notifications,  type: Boolean, default: true
  field :receives_digest, type: Boolean, default: true

  attr_accessible :username, :full_name, :location, :biography,
                  :password, :password_confirmation, :receives_mailed_notifications,
                  :receives_digest
  attr_accessible :username, :full_name, :location, :biography,
                  :password, :password_confirmation, :receives_mailed_notifications,
                  :receives_digest, :email, :admin, :registration_code,
        as: :admin

  USERNAME_BLACKLIST = [
    :users, :facts, :site, :templates, :search, :system, :tos, :pages, :privacy,
    :admin, :factlink, :auth, :reserved, :feedback, :feed, :client, :assets,
    :rails, :'terms-of-service', :f, :publisher, :publishers, :api,
    :'in-your-browser', :'on-your-site', :about, :jobs, :blog
  ].freeze
  # Only allow letters, digits and underscore in a username
  validates_format_of     :username,
                          :with => /\A.{2,}\Z/,
                          :message => "at least 2 characters needed"
  validates_format_of     :username,
                          :with => Regexp.new('^' + (USERNAME_BLACKLIST.map { |x| '(?!'+x.to_s+'$)' }.join '') + '.*'),
                          :message => "this username is reserved"
  validates_format_of     :username,
                          :with => /\A[A-Za-z0-9_]*\Z/i,
                          :message => "only letters, digits and _ are allowed"


  validates_uniqueness_of :username, :message => "Username already in use", :case_sensitive => false

  validates_length_of     :username, :within => 0..USERNAME_MAX_LENGTH, :message => "no more than #{USERNAME_MAX_LENGTH} characters allowed"
  validates_presence_of   :username, :message => "Username is required", :allow_blank => true # since we already check for length above
  validates_presence_of   :full_name, :message => "Full name is required", :allow_blank => false
  validates_length_of     :email, minimum: 1 # this gets precedence over email already taken (for nil email)
  validates_presence_of   :encrypted_password
  validates_length_of     :location, maximum: 127
  validates_length_of     :biography, maximum: 1023

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :omniauthable,
  devise :database_authenticatable,
  :recoverable,   # Password retrieval
  :rememberable,  # 'Remember me' box
  :trackable,     # Log sign in count, timestamps and IP address
  :validatable,   # Validation of email and password
  :confirmable,   # Require e-mail verification
  :registerable   # Allow registration

  ## Database authenticatable
    field :email,              :type => String, :default => ""
    field :encrypted_password, :type => String, :default => ""


  ## Recoverable
    field :reset_password_token,   :type => String
    field :reset_password_sent_at, :type => Time

  ## Rememberable
    field :remember_created_at, :type => Time

  ## Trackable
    field :sign_in_count,      :type => Integer
    field :current_sign_in_at, :type => Time
    field :last_sign_in_at,    :type => Time
    field :current_sign_in_ip, :type => String
    field :last_sign_in_ip,    :type => String

  ## Confirmable
    field :confirmation_token,   :type => String
    field :confirmed_at,         :type => Time
    field :confirmation_sent_at, :type => Time

  def comments
    Comments.where(created_by_id: self.id)
  end

  scope :active, where(:deleted.ne => true)

  class << self
    # List of fields that are stored in Mixpanel.
    # The key   represents how the field is stored in our Model
    # The value represents how it is stored in Mixpanel
    def mixpaneled_fields
      {
        "full_name"      => "name",
        "username"        => "username",
        "email"           => "email",
        "created_at"      => "created",
        "last_sign_in_at" => "last_login",
        "receives_mailed_notifications" => "receives_mailed_notifications",
        "receives_digest" => "receives_digest",
        "location"        => "location",
        "biography"       => "biography",
        "deleted"         => "deleted",
        "confirmed_at"    => "confirmed_at"
      }
    end

    # this methods defined which fields are to be removed
    # when the user is deleted (anonymized)
    def personal_information_fields
      %w(
        full_name location biography confirmed_at reset_password_token
        confirmation_token
      )
    end

    def valid_username?(username)
      validators = self.validators.select { |v| v.attributes == [:username] && v.options[:with].class == Regexp }.map { |v| v.options[:with] }
      case_insensitive_regexp = /\A#{Regexp.escape(username)}\z/i

      not find_by(username: case_insensitive_regexp) and validators.all? { |regex| regex.match(username) }
    end

    def import_export_simple_fields
      [:username, :full_name, :location, :biography,
      :receives_digest, :receives_mailed_notifications, :created_at,
      :updated_at, :deleted, :admin, :email,
      :registration_code, :reset_password_token, :reset_password_sent_at,
      :remember_created_at, :sign_in_count, :current_sign_in_at,
      :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip]
    end
  end

  before_save do |user|
    if user.changes.include? 'encrypted_password'
      Backend::Notifications.reset_edit_token user: self
    end
  end

  def hidden?
    !active?
  end

  def active?
    !deleted
  end

  def stream_activities
    activity_set(name: :stream_activities)
  end

  def own_activities
    activity_set(name: :own_activities)
  end

  def notifications
    activity_set(name: :notifications)
  end

  private def activity_set(name:)
    key = Nest.new('GraphUser')[graph_user_id][name]
    Ohm::Model::TimestampedSet.new(key, Ohm::Model::Wrapper.wrap(Activity))
  end

  private def create_graph_user
    graph_user = GraphUser.new
    graph_user.save
    self.graph_user_id = graph_user.id
  end
  before_create :create_graph_user

  def self.human_attribute_name(attr, options = {})
    attr.to_s == 'non_field_error' ? '' : super
  end

  def to_s
    name
  end

  def to_param
    username
  end

  def name
    full_name.blank? ? username : full_name
  end

  def full_name=(new_name)
    super new_name.strip
  end

  def valid_full_name_and_email?
    unless valid?
      errors.keys.each do |key|
        errors.delete key unless key == :full_name or key == :email
      end
    end
    not errors.any?
  end

  def generate_username!
    return unless full_name

    self.username = UsernameGenerator.new.generate_from full_name, USERNAME_MAX_LENGTH do |username|
      self.class.valid_username?(username)
    end
  end

  def serializable_hash(options={})
    options ||= {}
    options[:except] ||= []
    options[:except] += [:admin]
    super(options)
  end

  def self.from_param(param)
    find_by username: param
  end

  # Don't require being confirmed for being active for authentication
  # Do check for deleted accounts though!
  def active_for_authentication?
    !deleted
  end

  set :features
  def features=(values)
    values ||= []
    features.del
    values.each do |val|
      features << val
    end
  end

  def features_count
    @count ||= features.to_a.select { |f| Ability::FEATURES.include? f }.count
  end

  def social_accounts
    SocialAccount.where(user_id: id.to_s)
  end

  def social_account provider_name
    SocialAccount.where(provider_name: provider_name, user_id: id.to_s).first_or_initialize
  end

  # Override login mechanism to allow username or email logins
  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
  end

  # this backports a bug introduced by devise_invitable
  # by defining it we can reuse the original definition,
  # and keep it public
  def valid_password?(password)
    super
  end

  def update_search_index
    if active?
      fields = {username: username, full_name: full_name}
      ElasticSearch::Index.new('user').add id, fields
    else
      ElasticSearch::Index.new('user').delete id
    end
  end

  after_save do |user|
    user.update_search_index
  end

  after_update do |user|
    UserObserverTask.handle_changes user
  end
end
