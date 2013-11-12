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
      root_path
    end
  end

end
