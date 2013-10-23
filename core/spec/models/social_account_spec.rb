require 'spec_helper'

describe SocialAccount do
  describe '.find_by_provider_and_uid' do
    it 'returns null if it cannot find the user' do
      result = SocialAccount.find_by_provider_and_uid('facebook', 10)
      expect(result).to be_nil
    end

    it 'returns the social account for a provider and uid' do
      provider_name = 'facebook'
      uid = '10'
      omniauth_obj = {'uid' => uid, 'provider' => provider_name}

      social_account = SocialAccount.create!(provider_name: provider_name, omniauth_obj: omniauth_obj)

      result = SocialAccount.find_by_provider_and_uid(provider_name, uid)
      expect(result).to eq social_account
    end
  end

  describe '#provider_matches_omniauth_provider' do
    it 'validates the provider_name against the omniauth_obj' do
      attributes = {provider_name: 'twitter', omniauth_obj: {'uid' => '10', 'provider' => 'facebook'}}
      social_account = SocialAccount.new attributes

      expect(social_account).to_not be_valid
    end
  end

  describe '#presence_of_uid' do
    it 'checks that omniauth_obj contains uid' do
      attributes = {provider_name: 'twitter', omniauth_obj: {'provider' => 'twitter'}}
      social_account = SocialAccount.new attributes

      expect(social_account).to_not be_valid
    end
  end
end
