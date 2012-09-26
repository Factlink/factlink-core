require 'sunspot/rails/spec_helper'
require 'net/http'

start_server = proc do |timeout|
  server = Sunspot::Rails::Server.new
  server.start
  at_exit { server.stop }

  port = server.port
  uri = URI.parse("http://0.0.0.0:#{port}/solr/")

  timeout.times.find do           # wait till server starts
    begin
      Net::HTTP.get_response uri
      break server

    rescue Errno::ECONNREFUSED
      sleep 1
      next

    end
  end
end

original_session = nil            # always nil between specs
sunspot_server = nil              # one server shared by all specs

RSpec.configure do |config|

  config.before(:each) do
    if example.metadata[:solr]    # it "...", solr: true do ... to have real SOLR
      sunspot_server ||= start_server[60] || raise("SOLR connection timeout")
    else
      original_session = Sunspot.session
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new(original_session)
    end
  end

  config.after(:each) do
    if Sunspot.class != Class
      if example.metadata[:solr]
        Sunspot.remove_all!

      else
        Sunspot.session = original_session
      end
      original_session = nil
    end
  end
end
