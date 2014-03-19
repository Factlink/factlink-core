require_relative './html_editor'
require_relative './url_validator'

class WebProxy < Goliath::API
  def response(env)
    req = Rack::Request.new(env)
    requested_url = req.params['url']
    return redirect_to_factlink if requested_url.nil?

    url_validator = UrlValidator.new(requested_url)
    if url_validator.valid?
      requested_url = url_validator.normalized
    else
      return invalid_request
    end

    page = retrieve_page(env, requested_url)

    case page.response_header.status
    when 200
      env[:web_proxy_proxied] = true
      env[:web_proxy_proxied_location] = requested_url
      [200, {}, set_base(requested_url, page.response)]
    when 301, 302
      location = proxied_location(env, page.response_header['Location'])
      [
        page.response_header.status,
        { 'Location' => location },
        %Q(Redirecting to <a href="#{location}">#{location}</a>)
      ]
    end
  end

  def set_base(requested_url, html)
    escaped_url = CGI.escapeHTML(requested_url)
    new_base_tag = "<base href=\"#{escaped_url}\" />"

    HtmlEditor.prepend_to_head(html,new_base_tag)
  end

  def proxied_location(env, location)
    env.config[:host] + '/?url=' + CGI.escape(requested_url)
  end

  def retrieve_page(env, url)
    env.config[:http_requester].call(url)
  end

  def invalid_request
    [500, {}, 'Request was invalid, invalid url']
  end
end
