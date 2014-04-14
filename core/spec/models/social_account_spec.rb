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

      social_account = SocialAccount.create!(provider_name: provider_name, omniauth_obj_string: omniauth_obj.to_json)

      result = SocialAccount.find_by_provider_and_uid(provider_name, uid)
      expect(result).to eq social_account
    end
  end

  it 'saves the social account on the user' do
    provider_name = 'facebook'
    uid = '10'
    omniauth_obj = {'uid' => uid, 'provider' => provider_name}
    user = create :user

    social_account = SocialAccount.create!(provider_name: provider_name, omniauth_obj_string: omniauth_obj.to_json, user_id: user.id.to_s)

    expect(social_account.user.id).to eq user.id
  end

  describe '#provider_matches_omniauth_provider' do
    it 'validates the provider_name against the omniauth_obj' do
      attributes = {provider_name: 'twitter', omniauth_obj_string: {'uid' => '10', 'provider' => 'facebook'}.to_json}
      social_account = SocialAccount.new attributes

      expect(social_account).to_not be_valid
    end
  end

  describe '#presence_of_uid' do
    it 'checks that omniauth_obj contains uid' do
      attributes = {provider_name: 'twitter', omniauth_obj_string: {'provider' => 'twitter'}.to_json}
      social_account = SocialAccount.new attributes

      expect(social_account).to_not be_valid
    end
  end
end
