omniauth_conf = YAML::load_file(Rails.root.join('config/omniauth.yml'))[Rails.env]['omniauth']

Twitter.configure do |config|
  config.consumer_key    = omniauth_conf['twitter']['id']
  config.consumer_secret = omniauth_conf['twitter']['secret']
end
