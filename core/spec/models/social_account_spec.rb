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

  describe '#same_as?' do
    it 'returns false when not having an omniauth_obj' do
      social_account = SocialAccount.new
      omniauth_obj = {'uid' => '10'}

      expect(social_account.same_as?(omniauth_obj)).to be_false
    end

    it 'returns false for different uid' do
      social_account = SocialAccount.new omniauth_obj: {'uid' => '10'}

      expect(social_account.same_as?({'uid' => '20'})).to be_false
    end

    it 'returns true for the same uid' do
      uid = '10'
      social_account = SocialAccount.new omniauth_obj: {'uid' => uid}

      expect(social_account.same_as?({'uid' => uid})).to be_true
    end
  end
end
