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
      "/users/sign_in"
    else
      redirect_url_on_authentication_required
    end
  end

  # we requested a page, but we aren't authorized to see this page,
  # because we are not authenticated
  def redirect_url_on_authentication_required
    options = { return_to: request.original_url }

    if client_page
      user_session_path(options.merge(layout: 'client'))
    else
      root_path
    end
  end

  def client_page
    request.parameters[:layout] == 'client'
  end

end
