require 'spec_helper'

describe IdentitiesController do
  render_views

  describe 'service_callback' do
    context 'not yet signed in' do
      it 'signs in when a social account has been found' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        user = create :full_user

        user.social_account(provider_name).save_omniauth_obj!(omniauth_obj)

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :service_callback, service: 'facebook'

        expect(response.body).to match "eventName = 'signed_in'"
      end

      it 'gives an error when no user can be found' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        user = create :full_user

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :service_callback, service: 'facebook'

        expect(response.body).to match "eventName = 'social_error'"
      end
    end

    context 'already signed in' do
      it 'connects the social account' do
        provider_name = 'facebook'
        uid = '10'
        omniauth_obj = {'provider' => provider_name, 'uid' => uid}
        user = create :full_user

        sign_in user

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :service_callback, service: 'facebook'

        expect(response.body).to match "eventName = 'authorized'"
        expect(SocialAccount.first.omniauth_obj['uid']).to eq uid
      end

      it 'shows error when already connected to different user' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        other_omniauth_obj = {'provider' => provider_name, 'uid' => '20'}

        user = create :full_user
        user.social_account(provider_name).save_omniauth_obj!(omniauth_obj)
        sign_in user

        controller.request.env['omniauth.auth'] = other_omniauth_obj
        get :service_callback, service: 'facebook'

        expect(response.body).to match "eventName = 'social_error'"
      end
    end
  end
end
