require 'open-uri'
require 'digest/md5'
require 'redis/objects'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Redis::Objects

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  attr_accessor :tos_first_name, :tos_last_name

  field :username
  field :first_name
  field :last_name
  field :identities, type: Hash, default: {}

  index(username: 1)
  index({ "identities.facebook.uid" => 1 }, { sparse: true, unique: true })
  index({ "identities.twitter.uid" => 1 }, { sparse: true, unique: true })

  field :registration_code

  field :twitter
  field :location
  field :biography

  field :graph_user_id

  field :approved,    type: Boolean, default: false

  field :admin,       type: Boolean, default: false

  field :agrees_tos,  type: Boolean, default: false
  field :agrees_tos_name, type: String, default: ""
  field :agreed_tos_on,   type: DateTime

  field :seen_the_tour,  type: Boolean, default: false
  field :seen_tour_step, type: String,  default: nil
  field :receives_mailed_notifications,  type: Boolean, default: true
  field :receives_digest, type: Boolean, default: true


  field :last_read_activities_on, type: DateTime, default: 0
  field :last_interaction_at,     type: DateTime, default: 0

  attr_accessible :username, :first_name, :last_name, :twitter, :location, :biography, :password, :password_confirmation, :receives_mailed_notifications, :receives_digest
  field :invitation_message, type: String, default: ""
  attr_accessible :username, :first_name, :last_name, :twitter, :location, :biography, :password, :password_confirmation, :receives_mailed_notifications, :receives_digest, :email, :approved, :admin, :registration_code, as: :admin
  attr_accessible :agrees_tos_name, :agrees_tos, :agreed_tos_on, :first_name, :last_name, as: :from_tos

  # Only allow letters, digits and underscore in a username
  validates_format_of     :username,
                          :with => /\A.{2,}\Z/,
                          :message => "at least 2 characters needed"
  validates_format_of     :username,
                          :with => Regexp.new('^' + ([
                            :users,:facts,:site, :templates, :search, :system, :tos, :pages, :privacy, :admin, :factlink, :auth
                          ].map { |x| '(?!'+x.to_s+'$)'}.join '') + '.*'),
                          :message => "this username is reserved"
  validates_format_of     :username,
                          :with => /\A[A-Za-z0-9_]*\Z/i,
                          :message => "only letters, digits and _ are allowed"


  validates_uniqueness_of :username, :message => "already in use", :case_sensitive => false

  validates_length_of     :username, :within => 0..16, :message => "no more than 16 characters allowed"
  validates_presence_of   :username, :message => "is required", :allow_blank => true # since we already check for length above
  validates_presence_of   :first_name, :message => "is required", :allow_blank => false
  validates_presence_of   :last_name, :message => "is required", :allow_blank => false
  validates_length_of     :email, minimum: 1 # this gets precedence over email already taken (for nil email)
  validates_presence_of   :encrypted_password
  validates_length_of     :location, maximum: 127
  validates_length_of     :biography, maximum: 1023

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :omniauthable,
  devise :invitable, :database_authenticatable,
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


  ## Invitable
    field :invitation_token,  type: String
    field :invitation_sent_at, type: Time
    field :invitation_accepted_at, type: Time
    field :invitation_limit, type: Integer
    field :invited_by_id, type: String
    field :invited_by_type, type: String

  has_and_belongs_to_many :conversations, inverse_of: :recipients
  has_many :sent_messages, class_name: 'Message', inverse_of: :sender
  has_many :comments, class_name: 'Comment', inverse_of: :created_by

  class << self
    def seen_the_tour
      active.where(:seen_tour_step => 'tour_done')
    end

    def active
      approved.
        where(:confirmed_at.ne => nil).
        where(:agrees_tos => true)
    end

    def approved
      where(:approved => true)
    end

    def find_for_oauth(provider_name, uid)
      where(:"identities.#{provider_name}.uid" => uid).first
    end

    # List of fields that are stored in Mixpanel.
    # The key   represents how the field is stored in our Model
    # The value represents how it is stored in Mixpanel
    def mixpaneled_fields
      {
        "first_name"      => "first_name",
        "last_name"       => "last_name",
        "username"        => "username",
        "email"           => "email",
        "created_at"      => "created",
        "last_sign_in_at" => "last_login",
        "receives_digest" => "receives_digest",
        "location"        => "location",
        "bio"             => "bio"
      }
    end
  end

  after_invitation_accepted :approve_invited_user_and_create_activity
  def approve_invited_user_and_create_activity
    self.skip_confirmation!
    self.approved = true
    self.save

    Activity.create user: invited_by.graph_user, action: :invites, subject: graph_user
  end

  def hidden
    approved == false or
      not confirmed_at or
      agrees_tos == false
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

  def self.human_attribute_name(attr, options = {})
    attr.to_sym == :non_field_error ? '' : super
  end

  def sign_tos(agrees_tos)
    unless agrees_tos
      self.errors.add(:non_field_error, "You have to accept the Terms of Service to continue.")
      return false
    end

    attributes = {agrees_tos: agrees_tos, agreed_tos_on: DateTime.now}
    self.assign_attributes(attributes, as: :from_tos) and save
  end

  private :create_graph_user #WARING!!! is called by the database reset function to recreate graph_users after they were wiped, while users were preserved
  around_create :create_graph_user

  def to_s
    username
  end

  def to_param
    username
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def valid_username_and_email?
    unless valid?
      errors.keys.each do |key|
        errors.delete key unless key == :username or key == :email
      end
    end
    not errors.any?
  end

  def id_for_service service_name
    service_name = service_name.to_s
    if self.identities and self.identities[service_name]
      self.identities[service_name]['uid'].andand.first
    end
  end

  def serializable_hash(options={})
    options ||= {}
    options[:except] ||= Array.new
    options[:except] += [:admin, :agrees_tos, :agreed_tos_on, :agrees_tos_name, ]
    super(options)
  end

  def self.from_param(param)
    self.find_by username: param
  end

  # This function provides backwards compatibility with using #find(username)
  # Please refrain from doing this and use #find_by(username: username) instead
  # Remove this method when we don't use this crazy behaviour any more
  def self.find(param,*args)
    super || from_param(param)
  end

  def avatar_url(options={})
    options[:default] ||= :retro
    options[:rating] ||= :PG
    Gravatar.gravatar_url(email,options)
  end

  def gravatar_hash
    Gravatar.hash(email)
  end

  # Require activated accounts to work with
  # https://github.com/plataformatec/devise/wiki/How-To%3a-Require-admin-to-activate-account-before-sign_in
  def active_for_authentication?
    super && approved?
  end
  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
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

  set :seen_messages

  # don't send reset password instructions when the account is not approved yet
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  # Welcome the user with an email when the Admin approved the account
  def send_welcome_instructions
    generate_reset_password_token! if should_generate_reset_token?
    UserMailer.welcome_instructions(self.id).deliver
  end

  # Override login mechanism to allow username or email logins
  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
  end
end
