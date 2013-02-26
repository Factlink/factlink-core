class CustomDeviseFailure < Devise::FailureApp
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect_url
    if warden_options[:attempted_path] == "/users/sign_in"
      redirect_url_on_failed_login
    else
      redirect_url_on_authentication_required
    end
  end


  # We are logging in in this request, but we failed.
  def redirect_url_on_failed_login
      session[:redirect_after_failed_login_path] ||
      '/?show_sign_in=13'
  end

  # we requested a page, but we aren't authorized to see this page,
  # because we are not authenticated
  def redirect_url_on_authentication_required
    options = { return_to: request.original_url }

    if client_page
      user_session_path(options.merge(layout: 'client'))
    else
      root_path(options.merge(show_sign_in: 1))
    end
  end

  def client_page
    request.parameters[:layout] == 'client'
  end

end
