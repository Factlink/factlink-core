require_relative './html_editor'

class WebProxy < Goliath::API
  def response(env)
    req = Rack::Request.new(env)
    requested_url = req.params["url"]
    env[:web_proxy_proxied_location] = requested_url

    return redirect_to_factlink if requested_url.nil?

    page = EM::HttpRequest.new(requested_url).get

    case page.response_header.status
    when 200
      env[:web_proxy_proxied] = true
      [200, {}, update_head(requested_url, page.response)]
    when 301, 302
      location = proxied_location(page.response_header["Location"])
      [
        page.response_header.status,
        {'Location' => location},
        %Q(Redirecting to <a href="#{location}">#{location}</a>)
      ]
    end
  end

  def update_head requested_url, html
    html_editor = HtmlEditor.new(html)
    html_editor.prepend_to_head add_to_head(requested_url)
    html_editor.to_s
  end

  def add_to_head requested_url
    escaped_url = CGI.escapeHTML(requested_url)

    new_base_tag = "<base href=\"#{escaped_url}\" />"

    new_base_tag
  end

  def proxied_location(location)
    "http://localhost:4567/?url=" + CGI.escape(location)
  end
end
