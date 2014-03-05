class WebProxy < Goliath::API
  def response(env)
    req = Rack::Request.new(env)
    requested_url = req.params["url"]
    return redirect_to_factlink if requested_url.nil?

    page = EM::HttpRequest.new(requested_url).get

    case page.response_header.status
    when 200
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

  # We want to inject stuff into the <head>, but <head> may be implicit.
  # Though a <head> must officially have a <title>, omitting it doesn't break browsers, so what to detect?
  # Officially, every head needs a <title>, but invalid docs might omit it.  However, every head
  # needs *some* tag; we can just match the first tag that's not <head> or <html> - if a head really is empty, we'll match the closing </head> or <body> tags.
  #
  # Strategy: skip everything that's not a tag in the head:
  #  1. non '<' characters can be skipped; they're not interesting
  #  2. full comments <! -- comment --> can be skipped
  #  3. <head or <html can be skipped.
  #  4. <??? can be skipped when ??? isn't a closing tag so doesn't start with '/' and isn't an opening tag so doesn't start with 'a'-'z'
  # After this match we can't consume tokens and so must be at:
  # - the end of the document OR
  # - some string starting with '<' due to rule 1
  # -- BUT NOT a comment
  # -- AND NOT <html or <head
  # -- AND at a starting or closing tag.
  def regex_skip_until_in_html_head
    /(?:[^<]|<(?:!\s*--(?:(?!-->).)*-->|html|head|[^a-z\/]))*/i
  end

  def update_head requested_url, html
    html.sub regex_skip_until_in_html_head do
      $& + add_to_head(requested_url)
    end
  end

  def add_to_head requested_url
    new_base_tag = "<base href=\"#{requested_url}\" />"

    new_base_tag
  end

  def proxied_location(location)
    "http://localhost:4567/?url=" + CGI.escape(location)
  end
end
