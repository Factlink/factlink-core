# this test isn't in unit-spec because the IdentitiesController actually
# requires the ApplicationController, making this test kind-of slow

require_relative '../../app/controllers/identities_controller.rb'

describe IdentitiesController do
  describe 'service_callback' do
    it 'calls connect_provider when a user is signed in' do
      provider_name = double
      omniauth_obj = double

      subject.should_receive(:user_signed_in?).and_return(true)
      subject.stub(:parse_omniauth_env).and_return(omniauth_obj)
      subject.should_receive(:connect_provider).with(provider_name, omniauth_obj).and_return()
      subject.stub(:params => {:service => provider_name})
      subject.stub(:provider_name).and_return(provider_name)
      subject.should_receive(:respond_to)

      subject.service_callback
    end

    it 'calls sign_in_through_provider when a user is not logged in' do
      provider_name = double
      omniauth_obj = double

      subject.should_receive(:user_signed_in?).and_return(false)
      subject.stub(:parse_omniauth_env).and_return(omniauth_obj)
      subject.should_receive(:sign_in_through_provider).with(provider_name, omniauth_obj).and_return()
      subject.stub(:params => {:service => provider_name})
      subject.stub(:provider_name).and_return(provider_name)
      subject.should_receive(:respond_to)

      subject.service_callback()
    end
  end

  describe 'sign_in_through_provider' do
    it 'should sign a user in when one is found' do
      user = double
      provider_name = double
      omniauth_obj = mock(uid: true)

      stub_const("User", Class.new)
      User.should_receive(:find_for_oauth).with(provider_name, omniauth_obj.uid).and_return(user)

      subject.should_receive(:sign_in).with(user).and_return(true)
      subject.stub(:provider_name).and_return(provider_name)

      subject.send(:sign_in_through_provider, provider_name, omniauth_obj)
      subject.instance_variable_get('@event').should eq 'signed_in'
    end

    it 'should redirect to the correct path when no user is found' do
      user = false
      provider_name = mock(capitalize: true)
      omniauth_obj = mock(uid: true)


      stub_const("User", Class.new)
      User.should_receive(:find_for_oauth).with(provider_name, omniauth_obj.uid).and_return(user)

      redirect_url = mock
      env_hash = {'omniauth.origin' => redirect_url}
      subject.stub flash: Hash.new,
                   request: stub(:request,
                     env: env_hash)
      subject.stub(:provider_name).and_return(provider_name)

      subject.send(:sign_in_through_provider, provider_name, omniauth_obj)
    end
  end
end
