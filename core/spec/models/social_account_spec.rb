require 'spec_helper'

describe SocialAccount do
  describe '.find_by_uid' do
    it 'returns null if it cannot find the user' do
      result = SocialAccount.find_with_omniauth_obj('facebook', {'uid' => '10'})
      expect(result).to be_nil
    end

    it 'returns the social account for a provider and uid' do
      provider_name = 'facebook'
      uid = '10'
      omniauth_obj = {'uid' => uid}

      social_account = SocialAccount.create!(provider_name: provider_name, omniauth_obj: omniauth_obj)

      result = SocialAccount.find_with_omniauth_obj(provider_name, omniauth_obj)
      expect(result).to eq social_account
    end
  end
end
