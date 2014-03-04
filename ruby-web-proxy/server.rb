require 'sinatra'
require 'sinatra/async'
require 'net/http'

Sinatra.register Sinatra::Async

aget '/run' do
  EM.defer do
    url = URI.parse(params[:url])
    body Net::HTTP.get(url)
  end
end
