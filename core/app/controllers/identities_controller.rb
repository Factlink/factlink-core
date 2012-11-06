class IdentitiesController < ApplicationController
  # Got some inspiration from: http://www.communityguides.eu/articles/16

  def service_callback
    provider_callback params[:service]
  end

  def service_deauthorize
    service = params[:service]

    case service
    when 'facebook'
      provider_deauthorize service do |uid, token|
        response = HTTParty.delete("https://graph.facebook.com/#{uid}/permissions?access_token=#{token}")
        if response.code != 200 and response.code != 400
          raise "Facebook deauthorize failed: '#{response.body}'."
        end
      end
    when 'twitter'
      provider_deauthorize service do
        flash[:notice] = 'To complete, please deauthorize Factlink at the Twitter website.'
      end
    else
      raise "Wrong OAuth provider: #{omniauth[:provider]}"
    end
  end

  def oauth_failure
    if(params[:error_description].blank?)
      params[:error_description] ||= "unspecified error"
    end

    flash[:alert] = "Authorization failed: #{params[:error_description]}."
    redirect_to edit_user_path(current_user)
  end

  private
  def provider_callback provider_name
    omniauth_obj = parse_omniauth_env provider_name

    if user_signed_in?
      connect_provider provider_name, omniauth_obj
    else
      sign_in_through_provider provider_name, omniauth_obj
    end
  end

  def connect_provider provider_name, omniauth_obj
    authorize! :update, current_user

    if omniauth_obj
      current_user.identities[provider_name] = omniauth_obj
      current_user.save
      flash[:notice] = "Succesfully connected."
    else
      flash[:alert] = "Error connecting."
    end

  	redirect_to edit_user_path(current_user)
  end

  def sign_in_through_provider provider_name, omniauth_obj
    @user = User.find_for_oauth(provider_name, omniauth_obj.uid)

    if @user
      sign_in_and_redirect @user
    else
      flash[:alert] = "No connected #{provider_name.capitalize} account found. Please sign in with your credentials and connect your #{provider_name.capitalize} account."
      redirect_to session[:redirect_after_failed_login_path]
    end
  end

  def parse_omniauth_env provider_name
    omniauth = request.env['omniauth.auth']
    if provider_name != omniauth[:provider]
      raise "Wrong OAuth provider: #{omniauth[:provider]}"
    end

    if omniauth[:uid] and omniauth[:credentials] and omniauth[:credentials][:token]
      if provider_name == 'twitter'
        omniauth['extra']['oath_version'] = omniauth['extra']['access_token'].consumer.options[:oauth_version];
        omniauth['extra']['signature_method'] = omniauth['extra']['access_token'].consumer.options[:signature_method]
        omniauth['extra'].delete 'access_token'
      end

      omniauth
    else
      false
    end
  end

  def provider_deauthorize provider_name, &block
    authorize! :update, current_user

    if(current_user.identities[provider_name])

      uid = current_user.identities[provider_name]['uid']
      token = current_user.identities[provider_name]['credentials']['token']

      begin
        block.call uid, token
        current_user.identities.delete(provider_name)
        current_user.save
        flash[:notice] ||= "Succesfully disconnected."
      rescue => e
        flash[:alert] = "Error disconnecting. #{e.message}"
      end
    else
      flash[:alert] = "Already disconnected."
    end

    redirect_to edit_user_path(current_user)
  end
end
