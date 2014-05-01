require 'spec_helper'

describe Accounts::SocialConnectionsController do
  render_views

  let(:extra_hash) do
    {'raw_info' => {'profile_image_url_https' => 'https://pbs.twimg.com/profile_images/1267267045/mijnhoofd_normal.png'}}
  end

  describe :callback do
    it 'connects the social account' do
      provider_name = 'twitter'
      uid = '10'
      omniauth_obj = {'provider' => provider_name, 'uid' => uid, "extra" => extra_hash}
      user = create :user

      sign_in user

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "account_success"'
      expect(SocialAccount.first.uid).to eq uid
    end

    it 'replaces social account when already connected to different social account' do
      provider_name = 'twitter'
      old_uid = '10'
      new_uid = '20'
      old_omniauth_obj = {'provider' => provider_name, 'uid' => old_uid, 'extra' => extra_hash}
      new_omniauth_obj = {'provider' => provider_name, 'uid' => new_uid, 'extra' => extra_hash}

      user = create :user
      user.social_account(provider_name).update_omniauth_obj!(old_omniauth_obj)
      sign_in user

      controller.request.env['omniauth.auth'] = new_omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "account_success"'
      expect(user.social_account(provider_name).uid).to eq new_uid
    end

    it 'removes spurious earlier social account objects' do
      provider_name = 'twitter'
      omniauth_obj = {'provider' => provider_name, 'uid' => 'uid', 'extra' => extra_hash}
      create :social_account, :twitter, omniauth_obj_string: omniauth_obj.to_json

      user = create :user
      sign_in user

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "account_success"'
      expect(user.social_account(provider_name).uid).to eq 'uid'
    end

    it 'shows an error when another user has been connected to that account already' do
      provider_name = 'twitter'
      omniauth_obj = {'provider' => provider_name, 'uid' => 'uid', 'extra' => extra_hash}

      user = create :user
      sign_in user

      other_user = create :user
      other_user.social_account(provider_name).update_omniauth_obj!(omniauth_obj)

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "account_error"'
    end
  end
end
