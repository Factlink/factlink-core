::SecureHeaders::Configuration.configure do |config|
  config.hsts = {:max_age => 1.month.to_i}
  config.x_frame_options = 'DENY'
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = {:value => 1, :mode => 'block'}
  config.csp = false
end
