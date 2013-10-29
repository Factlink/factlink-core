require 'spec_helper'

describe SocialAccounts::ConnectionsController do
  render_views

  describe :callback do
    it 'connects the social account' do
      provider_name = 'facebook'
      uid = '10'
      omniauth_obj = {'provider' => provider_name, 'uid' => uid}
      user = create :full_user

      sign_in user

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: 'facebook'

      expect(response.body).to match 'eventName = "authorized"'
      expect(SocialAccount.first.omniauth_obj['uid']).to eq uid
    end

    it 'shows error when already connected to different social account' do
      provider_name = 'facebook'
      omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
      other_omniauth_obj = {'provider' => provider_name, 'uid' => '20'}

      user = create :full_user
      user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)
      sign_in user

      controller.request.env['omniauth.auth'] = other_omniauth_obj
      get :callback, provider_name: 'facebook'

      expect(response.body).to match 'eventName = "social_error"'
    end
  end
end
