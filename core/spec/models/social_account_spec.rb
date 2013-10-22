require 'spec_helper'

describe SocialAccount do
  describe '.find_by_uid' do
    it 'returns null if it cannot find the user' do
      result = SocialAccount.find_by_provider_and_uid('facebook', 10)
      expect(result).to be_nil
    end

    it 'returns the social account for a provider and uid' do
      provider_name = 'facebook'
      uid = '10'
      omniauth_obj = {'uid' => uid}

      social_account = SocialAccount.create!(provider_name: provider_name, omniauth_obj: omniauth_obj)

      result = SocialAccount.find_by_provider_and_uid(provider_name, uid)
      expect(result).to eq social_account
    end
  end

  describe '#different_from?' do
    it 'returns false when not having an omniauth_obj' do
      social_account = SocialAccount.new
      omniauth_obj = {'uid' => '10'}

      expect(social_account.different_from?(omniauth_obj)).to be_false
    end

    it 'returns true for different uid' do
      social_account = SocialAccount.new omniauth_obj: {'uid' => '10'}

      expect(social_account.different_from?({'uid' => '20'})).to be_true
    end

    it 'returns false for the same uid' do
      uid = '10'
      social_account = SocialAccount.new omniauth_obj: {'uid' => uid}

      expect(social_account.different_from?({'uid' => uid})).to be_false
    end
  end
end
