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
    else
      raise "Wrong OAuth provider: #{omniauth[:provider]}"
    end
  end

  def oauth_failure
    flash[:alert] = "Authorization failed: #{params[:error_description]}"
    redirect_to edit_user_path(current_user)
  end

  private
  def provider_callback provider_name
    authorize! :update, current_user

  	omniauth = request.env['omniauth.auth']

  	if provider_name != omniauth[:provider]
  		raise "Wrong OAuth provider: #{omniauth[:provider]}"
  	end

    if omniauth[:uid] and omniauth[:credentials] and omniauth[:credentials][:token]
      current_user.identities[provider_name] = omniauth
      current_user.save 
      flash[:notice] = "Succesfully connected."
    else
      flash[:alert] = "Error connecting."
    end

  	redirect_to edit_user_path(current_user)
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
        flash[:notice] = "Succesfully disconnected."
      rescue => e
        flash[:alert] = "Error disconnecting. #{e.message}"
      end
    else
      flash[:alert] = "Already disconnected."
    end
    
    redirect_to edit_user_path(current_user)
  end
end
