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
        Approvals.verify(c.response, name: 'server_200')
      end
    end
  end

  it "redirects to a specified url when no url has been provided" do
    with_api(Server) do |server|
      backup_url = "http://someurl.example.org/"
      server.config[:redirect_for_no_url] = backup_url

      get_request(path: '/') do |c|
        expect(c.response_header.status).to eq 301
        expect(c.response_header['Location']).to eq "http://someurl.example.org/"
      end
    end
  end
end
