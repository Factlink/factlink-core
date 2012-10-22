Airbrake.configure do |config|
   config.api_key     = '15ac8a10c7b9e8939aa5608e186d3fd8'
   config.host        = 'factlink-errbit.herokuapp.com'
   config.port        = 80
   config.secure      = config.port == 443

   config.rescue_rake_exceptions = true # report exceptions that happen inside a rake task
end
