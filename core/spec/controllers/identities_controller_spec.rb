require_relative '../../app/controllers/identities_controller.rb'

describe IdentitiesController do
  describe 'service_callback' do
    it 'calls connect_provider when a user is signed in' do
      provider_name = mock()
      omniauth_obj = mock()

      subject.should_receive(:user_signed_in?).and_return(true)
      subject.stub(:parse_omniauth_env).and_return(omniauth_obj)
      subject.should_receive(:connect_provider).with(provider_name, omniauth_obj).and_return()
      subject.stub(:params => {:service => provider_name})

      subject.service_callback()
    end

    it 'calls sign_in_through_provider when a user is not logged in' do
      provider_name = mock()
      omniauth_obj = mock()

      subject.should_receive(:user_signed_in?).and_return(false)
      subject.stub(:parse_omniauth_env).and_return(omniauth_obj)
      subject.should_receive(:sign_in_through_provider).with(provider_name, omniauth_obj).and_return()
      subject.stub(:params => {:service => provider_name})

      subject.service_callback()
    end
  end

  describe 'sign_in_through_provider' do
    it 'should sign a user in when one is found' do
      user = mock()
      provider_name = mock()
      omniauth_obj = mock(uid: true)

      stub_const("User", Class.new)
      User.should_receive(:find_for_oauth).with(provider_name, omniauth_obj.uid).and_return(user)

      subject.should_receive(:sign_in_and_redirect).with(user).and_return(true)

      subject.send(:sign_in_through_provider, provider_name, omniauth_obj)
    end

    it 'should redirect to the correct path when no user is found' do
      user = false
      provider_name = mock(capitalize: true)
      omniauth_obj = mock(uid: true)

      session = mock()
      session.stub(:[]).with(:redirect_after_failed_login_path).and_return(true)

      stub_const("User", Class.new)
      User.should_receive(:find_for_oauth).with(provider_name, omniauth_obj.uid).and_return(user)

      subject.should_receive(:session).and_return(session)
      subject.should_receive(:flash).and_return(Hash.new)
      subject.should_receive(:redirect_to).with(session[:redirect_after_failed_login_path]).and_return(true)

      subject.send(:sign_in_through_provider, provider_name, omniauth_obj)
    end
  end
end
