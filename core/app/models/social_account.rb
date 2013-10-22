class SocialAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider_name, type: String
  field :omniauth_obj, type: Hash
  validates_presence_of :provider_name
  validates_presence_of :omniauth_obj

  belongs_to :user, index: true

  index({provider_name: 1, 'omniauth_obj.uid' => 1}, { unique: true })

  class << self
    def find_by_provider_and_uid(provider_name, uid)
      find_by(:provider_name => provider_name, :'omniauth_obj.uid' => uid)
    end
  end

  def different_from?(omniauth_obj)
    self.omniauth_obj && self.omniauth_obj['uid'] != omniauth_obj['uid']
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
end
