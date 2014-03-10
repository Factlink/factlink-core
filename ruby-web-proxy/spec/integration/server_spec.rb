require 'spec_helper'
require_relative '../../server.rb'

describe Server do
  let(:http_requester) { double :http_requester }

  def mock_http_requests server
    server.config[:http_requester] = http_requester
  end

  def mock_http_response status, content
    double({
      response_header: double({
        status: status
      }),
      response: content,
    })
  end

  it "does a working proxy request for a page" do
    request_url = 'http://www.example.org/foo?bar=baz'

    url_html = <<-EOHTML.squeeze(' ').gsub(/^ /,'')
      <!DOCTYPE html>
      <html>
      <title>Hoi</title>
      <h1>yo</h1>
    EOHTML

    with_api(Server) do |server|
      mock_http_requests(server)
      expect(http_requester)
        .to receive(:call)
        .with(request_url)
        .and_return mock_http_response(200, url_html)

      get_request(query: {url: request_url}) do |c|
        Approvals.verify(c.response, name: 'foo')
      end
    end
  end
end
