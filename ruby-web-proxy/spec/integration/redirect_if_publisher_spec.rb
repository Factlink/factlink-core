require 'spec_helper'
require_relative '../../lib/web_proxy.rb'
require_relative '../../lib/redirect_if_publisher.rb'

describe RedirectIfPublisher do
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

  it "redirects to the original page if a publisher page was returned" do
    request_url = 'http://www.example.org/foo?bar=baz'

    url_html = <<-EOHTML.squeeze(' ').gsub(/^ /,'')
      <!DOCTYPE html>
      <html>
      <title>Hoi</title>
      <h1>yo</h1>
      <script src="http://host/factlink_loader.min.js"></script>
    EOHTML

    server_with_redirect = Class.new(WebProxy)
    server_with_redirect.use RedirectIfPublisher

    with_api(server_with_redirect) do |server|
      mock_http_requests(server)
      expect(http_requester)
        .to receive(:call)
        .with(request_url)
        .and_return mock_http_response(200, url_html)

      get_request(query: {url: request_url}) do |c|
        expect(c.response_header.status).to eq 301
        expect(c.response_header['Location']).to eq request_url
      end
    end
  end
end
