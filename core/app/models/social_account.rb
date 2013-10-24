class SocialAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider_name, type: String
  field :omniauth_obj, type: Hash
  validates_presence_of :provider_name
  validates_presence_of :omniauth_obj
  validate :presence_of_uid
  validate :provider_matches_omniauth_provider

  belongs_to :user, index: true

  index({provider_name: 1, 'omniauth_obj.uid' => 1}, { unique: true })

  class << self
    def find_by_provider_and_uid(provider_name, uid)
      find_by(:provider_name => provider_name, :'omniauth_obj.uid' => uid)
    end
  end

  def uid
    omniauth_obj['uid']
  end

  def token
    omniauth_obj['credentials']['token']
  end

  def secret
    omniauth_obj['credentials']['secret']
  end

  def expires_at
    omniauth_obj['credentials']['expires_at']
  end

  def name
    omniauth_obj['info']['name']
  end

  private

  before_save :strip_twitter_access_token
  def strip_twitter_access_token
    if provider_name == 'twitter' && omniauth_obj['extra'] && omniauth_obj['extra']['access_token']
      omniauth_obj['extra']['oath_version'] = omniauth_obj['extra']['access_token'].consumer.options['oauth_version']
      omniauth_obj['extra']['signature_method'] = omniauth_obj['extra']['access_token'].consumer.options['signature_method']
      omniauth_obj['extra'].delete 'access_token'
    end
  end

  def provider_matches_omniauth_provider
    if provider_name != omniauth_obj['provider']
      errors.add :provider_name, 'does not match omniauth_obj provider'
    end
  end

  def presence_of_uid
    unless omniauth_obj['uid']
      errors.add :omniauth_obj, 'does not contain uid'
    end
  end
end
