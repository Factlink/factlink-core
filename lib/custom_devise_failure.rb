class CustomDeviseFailure < Devise::FailureApp
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect_url
    root_path(return_to: request.original_url)
  end
end
