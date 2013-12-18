module Acceptance::ClientPathHelper
  def new_fact_path displaystring: 'something'
    encoded_displaystring = CGI.escape(displaystring)
    "/client/facts/new?displaystring=#{encoded_displaystring}"
  end
end
