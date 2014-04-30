require 'open-uri'
require 'digest/md5'

class User < ActiveRecord::Base
  include PgSearch

  multisearchable against: [:username, :full_name, :location, :biography],
                  :if => :active?

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  :recoverable,   # Password retrieval
  :rememberable,  # 'Remember me' box
  :trackable,     # Log sign in count, timestamps and IP address
  :validatable,   # Validation of email and password
  :confirmable,   # Require e-mail verification
  :registerable   # Allow registration

  attr_accessible :username, :full_name, :location, :biography,
                  :password, :password_confirmation, :receives_mailed_notifications,
                  :receives_digest
  attr_accessible :username, :full_name, :location, :biography,
                  :password, :password_confirmation, :receives_mailed_notifications,
                  :receives_digest, :email, :admin,
        as: :admin

  has_many :features
  has_many :activities
  has_many :activities_with_user_as_subject, as: :subject, class_name: :Activity
  has_and_belongs_to_many :groups

  after_initialize :set_default_values!
  def set_default_values!
    {
      deleted: false,
      admin: false,
      receives_mailed_notifications: true,
      receives_digest: true,
    }.each do |attribute_name, default_value|
      self[attribute_name] = default_value unless attribute_present?(attribute_name)
    end
  end

  USERNAME_MAX_LENGTH = 20

  #index(username: 1)

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
                          :with => Regexp.new('\A' + (USERNAME_BLACKLIST.map { |x| '(?!'+x.to_s+'$)' }.join '') + '.*'),
                          :message => "this username is reserved"
  validates_format_of     :username,
                          :with => /\A[a-z0-9_]*\Z/i,
                          :message => "only (lowercase) letters, digits and _ are allowed"
  before_validation :username_to_lowercase
  def username_to_lowercase
    self.username = self.username.downcase if self.username
  end

  validates_uniqueness_of :username, :message => "Username already in use", :case_sensitive => false

  validates_length_of     :username, :within => 0..USERNAME_MAX_LENGTH, :message => "no more than #{USERNAME_MAX_LENGTH} characters allowed"
  validates_presence_of   :username, :message => "Username is required", :allow_blank => true # since we already check for length above
  validates_presence_of   :full_name, :message => "Full name is required", :allow_blank => false
  validates_length_of     :email, minimum: 1 # this gets precedence over email already taken (for nil email)
  validates_presence_of   :encrypted_password
  validates_length_of     :location, maximum: 127
  validates_length_of     :biography, maximum: 1023

  def comments
    Comments.where(created_by_id: self.id)
  end

  scope :active, ->{ where(deleted: false) }

  class << self
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

      where(username: username.downcase).count == 0 and validators.all? { |regex| regex.match(username) }
    end

    def import_export_simple_fields
      [:username, :full_name, :location, :biography,
      :receives_digest, :receives_mailed_notifications, :created_at,
      :updated_at, :deleted, :admin, :email,
      :reset_password_token, :reset_password_sent_at,
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

  def self.human_attribute_name(attr, options = {})
    attr.to_s == 'non_field_error' ? '' : super
  end

  def generate_username!
    return unless full_name

    self.username = UsernameGenerator.new.generate_from full_name, USERNAME_MAX_LENGTH do |username|
      self.class.valid_username?(username)
    end
  end

  # Don't require being confirmed for being active for authentication
  # Do check for deleted accounts though!
  def active_for_authentication?
    !deleted
  end

  def social_accounts
    SocialAccount.where(user_id: id.to_s)
  end

  def social_account provider_name
    SocialAccount.where(provider_name: provider_name, user_id: id.to_s).first_or_initialize
  end

  # this backports a bug introduced by devise_invitable
  # by defining it we can reuse the original definition,
  # and keep it public
  def valid_password?(password)
    super
  end
end
