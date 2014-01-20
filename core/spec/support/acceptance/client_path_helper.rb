module Acceptance::ClientPathHelper
  def new_fact_path displaystring: 'something', url: 'http://example.org'
    encoded_displaystring = CGI.escape(displaystring)
    encoded_url = CGI.escape(url)

    "/client/facts/new?displaystring=#{encoded_displaystring}&url=#{encoded_url}"
  end
end
