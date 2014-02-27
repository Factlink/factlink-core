class Accounts::SocialConnectionsController < Accounts::BaseController
  around_filter :render_trigger_event_on_social_account_error,
    except: [:deauthorize] # deauthorize is not rendered in popup

  def callback
    authorize! :update, current_user

    fail AccountError, "Error connecting." unless omniauth_obj

    social_account = SocialAccount.find_by_provider_and_uid(provider_name, omniauth_obj['uid'])

    if social_account && social_account.user && social_account.user != current_user
      fail AccountError, "Already connected to a different account, please sign in to the connected account or reconnect your account."
    end

    if social_account # spurious or already connected account
      social_account.delete #TODO:otherdelete?  social_account is mongoid.
    end

    current_user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)
    render_trigger_event 'authorized', provider_name
  end

  def deauthorize
    authorize! :update, current_user

    social_account = current_user.social_account(params[:provider_name])

    if social_account.persisted?
      case social_account.provider_name
      when 'facebook'
        deauthorize_facebook social_account
      when 'twitter'
        deauthorize_twitter social_account
      end
    else
      flash[:alert] = "Already disconnected."
    end

    redirect_to edit_user_path(current_user)
  end

  def oauth_failure
    render_trigger_event 'account_error', "Authorization failed: #{params[:error_description]}."
  end

  private

  def deauthorize_facebook social_account
    uid = social_account.omniauth_obj['uid']
    token = social_account.omniauth_obj['credentials']['token']

    social_account.delete #TODO:otherdelete?

    response = HTTParty.delete("https://graph.facebook.com/#{uid}/permissions?access_token=#{token}")
    if response.code == 200 || response.code == 400
      flash[:notice] = 'Succesfully disconnected.'
    else
      flash[:notice] = 'To complete, please deauthorize Factlink at the Facebook website.'
    end
  end

  def deauthorize_twitter social_account
    social_account.delete #TODO:otherdelete?
    flash[:notice] = 'To complete, please deauthorize Factlink at the Twitter website.'
  end
end
