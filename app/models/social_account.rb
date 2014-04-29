class SocialAccount < ActiveRecord::Base
  attr_accessible :omniauth_obj_id, :omniauth_obj_string, :provider_name, :user_id, :created_at, :updated_at

  validates_presence_of :provider_name
  validates_presence_of :omniauth_obj_string
  validates_presence_of :omniauth_obj_id
  validate :provider_matches_omniauth_provider
  validate :uniqueness_of_uid

  def user
    User.where(id: user_id).first
  end

  def user=(user)
    self.user_id = user.id.to_s
  end

  #index({provider_name: 1, omniauth_obj_id: 1}, { unique: true })

  class << self
    def find_by_provider_and_uid(provider_name, uid)
      where(provider_name: provider_name, omniauth_obj_id: uid.to_s).first
    end

    def import_export_simple_fields
      [:provider_name, :omniauth_obj_string, :created_at, :updated_at]
    end
  end

  def omniauth_obj
    JSON.parse(omniauth_obj_string)
  end

  def uid
    omniauth_obj_id
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

  def email
    if omniauth_obj['info'] &&
       omniauth_obj['info']['email'] &&
       !omniauth_obj['info']['email'].end_with?('@facebook.com')

      omniauth_obj['info']['email']
    else
      nil
    end
  end

  def update_omniauth_obj!(omniauth_obj)
    if provider_name == 'twitter' && omniauth_obj['extra'] && omniauth_obj['extra']['access_token']
      omniauth_obj['extra']['oath_version'] = omniauth_obj['extra']['access_token'].consumer.options['oauth_version']
      omniauth_obj['extra']['signature_method'] = omniauth_obj['extra']['access_token'].consumer.options['signature_method']
      omniauth_obj['extra'].delete 'access_token'
    end

    self.update_attributes!(omniauth_obj_string: omniauth_obj.to_json)
  end

  private

  before_validation :add_uid_to_model
  def add_uid_to_model
    self.omniauth_obj_id = omniauth_obj['uid']
  end

  def provider_matches_omniauth_provider
    if provider_name != omniauth_obj['provider']
      errors.add :provider_name, 'does not match omniauth_obj provider'
    end
  end

  def uniqueness_of_uid
    other_social_account = self.class.find_by_provider_and_uid(provider_name, uid)

    if other_social_account and other_social_account != self
      errors.add :omniauth_obj, 'account already exists'
    end
  end
end
