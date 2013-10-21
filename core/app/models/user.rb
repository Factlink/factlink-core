require 'open-uri'
require 'digest/md5'
require 'redis/objects'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Redis::Objects

  embeds_one :user_notification, autobuild: true

  USERNAME_MAX_LENGTH = 20 # WARNING: must be shorter than mongo ids(24 chars) to avoid confusing ids with usernames!

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  attr_accessor :tos_first_name, :tos_last_name

  field :username
  field :first_name
  field :last_name

  index(username: 1)

  field :registration_code

  field :location
  field :biography

  field :graph_user_id

  field :deleted,     type: Boolean, default: false
  field :set_up,      type: Boolean, default: false
  field :suspended,   type: Boolean, default: false # For now this is just for users we don't want to invite yet.

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

  attr_accessible :username, :first_name, :last_name, :location, :biography,
                  :password, :password_confirmation, :receives_mailed_notifications,
                  :receives_digest
  field :invitation_message, type: String, default: ""
  attr_accessible :username, :first_name, :last_name, :location, :biography,
                  :password, :password_confirmation, :receives_mailed_notifications,
                  :receives_digest, :email, :admin, :registration_code, :suspended,
        as: :admin
  attr_accessible :agrees_tos_name, :agrees_tos, :agreed_tos_on, :first_name, :last_name,
        as: :from_tos

  USERNAME_BLACKLIST = [
    :users, :facts, :site, :templates, :search, :system, :tos, :pages, :privacy,
    :admin, :factlink, :auth, :reserved, :feedback, :feed, :client, :assets,
    :rails
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


  validates_uniqueness_of :username, :message => "already in use", :case_sensitive => false

  validates_length_of     :username, :within => 0..USERNAME_MAX_LENGTH, :message => "no more than #{USERNAME_MAX_LENGTH} characters allowed"
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
  has_many :social_accounts

  scope :active,   where(:set_up => true)
                  .where(:agrees_tos => true)
                  .where(:deleted.ne => true)
                  .where(:suspended.ne => true)
  scope :seen_the_tour,   active
                            .where(:seen_tour_step => 'tour_done')

  class << self
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
        "receives_mailed_notifications" => "receives_mailed_notifications",
        "receives_digest" => "receives_digest",
        "location"        => "location",
        "biography"       => "biography",
        "deleted"         => "deleted",
        "suspended"       => "suspended",
        "confirmed_at"    => "confirmed_at"
      }
    end

    # this methods defined which fields are to be removed
    # when the user is deleted (anonymized)
    def personal_information_fields
      # Deliberately not removing agrees_tos_name for now
      %w(
        first_name last_name location biography confirmed_at reset_password_token
        confirmation_token invitation_token
      )
    end
  end

  before_save do |user|
    if user.changes.include? 'encrypted_password'
      user.user_notification.reset_notification_settings_edit_token
    end
  end

  after_invitation_accepted :skip_confirmation_and_create_invited_activity
  def skip_confirmation_and_create_invited_activity
    self.skip_confirmation!
    self.save

    Activity.create user: invited_by.graph_user, action: :invites, subject: graph_user
  end

  def hidden?
    !active?
  end

  def active?
    set_up && agrees_tos && !deleted && !suspended
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
    attr.to_s == 'non_field_error' ? '' : super
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
    name
  end

  def to_param
    username
  end

  def name
    name = "#{first_name} #{last_name}".strip

    if name.blank?
      username
    else
      name
    end
  end

  def valid_username_and_email?
    unless valid?
      errors.keys.each do |key|
        errors.delete key unless key == :username or key == :email
      end
    end
    not errors.any?
  end

  def serializable_hash(options={})
    options ||= {}
    options[:except] ||= []
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

  # Don't require being confirmed for being active for authentication
  # Do check for deleted and suspended accounts though!
  def active_for_authentication?
    !deleted && !suspended
  end

  def inactive_message
    if suspended
      :suspended
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

  def social_account provider_name
    self.social_accounts.where(provider_name: provider_name).first || self.social_accounts.new(provider_name: provider_name)
  end

  set :seen_messages

  # don't send reset password instructions when the account is suspended
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if recoverable.suspended
      recoverable.errors[:base] << I18n.t("devise.failure.suspended")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  # Override login mechanism to allow username or email logins
  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
  end

  def pending_any_confirmation
    yield # Always allow confirmation, so users can login again.
    # Used together with ConfirmationsController#restore_confirmation_token
  end

  # Fix for devise, for a case that should never happen at production
  def confirmation_period_expired?
    return false unless self.confirmation_sent_at

    super
  end
end
