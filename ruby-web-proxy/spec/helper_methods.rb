module HelperMethods
  def mock_http_requests server
    server.config[:http_requester] = http_requester
  end

  def mock_http_response status, content, headers: {}
    double({
      response_header: Hashie::Mash.new({
          status: status
        }.merge(headers)),
      response: content,
    })
  end
end
