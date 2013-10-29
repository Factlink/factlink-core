class SocialAccounts::ConnectionsController < SocialAccounts::BaseController
  around_filter :render_trigger_event_on_social_account_error,
    except: [:deauthorize] # deauthorize is not rendered in popup

  def callback
    authorize! :update, current_user

    if is_connected_to_different_user
      fail SocialAccountError, "Already connected to a different account, please sign in to the connected account or reconnect your account."
    elsif omniauth_obj
      current_user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)
      render_trigger_event 'authorized', provider_name
    else
      fail SocialAccountError, "Error connecting."
    end
  end

  def deauthorize
    authorize! :update, current_user

    social_account = current_user.social_account(params[:provider_name])
    fail SocialAccountError, "Already disconnected." unless social_account.persisted?

    case social_account.provider_name
    when 'facebook'
      deauthorize_facebook social_account
    when 'twitter'
      deauthorize_twitter social_account
    end
  rescue SocialAccountError => error
    flash[:alert] = "Error disconnecting: #{error.message}"
  ensure
    redirect_to edit_user_path(current_user)
  end

  def oauth_failure
    render_trigger_event 'social_error', "Authorization failed: #{params[:error_description]}."
  end

  private

  def is_connected_to_different_user
    social_account = current_user.social_account(provider_name)

    social_account.persisted? && social_account.uid != omniauth_obj['uid']
  end

  def deauthorize_facebook social_account
    uid = social_account.omniauth_obj['uid']
    token = social_account.omniauth_obj['credentials']['token']
    response = HTTParty.delete("https://graph.facebook.com/#{uid}/permissions?access_token=#{token}")

    fail SocialAccountError, response.body if response.code != 200 and response.code != 400

    social_account.delete
    flash[:notice] = "Succesfully disconnected."
  end

  def deauthorize_twitter social_account
    social_account.delete
    flash[:notice] = 'To complete, please deauthorize Factlink at the Twitter website.'
  end
end
