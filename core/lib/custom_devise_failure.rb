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
      # We are logging in in this request, but we failed.

      session[:redirect_after_failed_login_path] || '/?show_sign_in=1'
    else
      # we requested a page, but we aren't authorized to see this page,
      # because we are not authenticated

      root_path(show_sign_in: 1, return_to: request.original_url)
    end
  end
end
