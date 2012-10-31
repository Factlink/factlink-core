module UrlHelper
  # Send Devise emails from subdomain
  # https://github.com/plataformatec/devise/wiki/How-To:-Send-emails-from-subdomains
  def set_mailer_url_options
    ActionMailer::Base.default_url_options[:host] = with_subdomain(request.subdomain)
    ActionMailer::Base.default_url_options[:port] = request.port_string

    puts ActionMailer::Base.default_url_options
  end

  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain].join
  end
end
