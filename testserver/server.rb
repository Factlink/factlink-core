require 'rubygems'
require 'sinatra'

set :port, 12345 # keep in synch with testfile

get '/' do
  'Hello world!'
end

get '/delayed_javascript' do

  sleep params.fetch(:delay, 3)

  [
    200,
    {
      'Content-Type' => 'application/javascript'
    },
    'console.log("loaded intentionally delayed script ('+params[:delay]+' seconds)!");'
  ]
end
