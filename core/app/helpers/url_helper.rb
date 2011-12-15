module UrlHelper
  # Send Devise emails from subdomain
  # https://github.com/plataformatec/devise/wiki/How-To:-Send-emails-from-subdomains
  def set_mailer_url_options
    ActionMailer::Base.default_url_options[:host] = with_subdomain(request.subdomain)
  end
end