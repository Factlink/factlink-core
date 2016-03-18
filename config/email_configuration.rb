sendgrid_settings = {
  port:           '587',
  address:        'smtp.sendgrid.net',
  user_name:      ENV['SENDGRID_USERNAME'],
  password:       ENV['SENDGRID_APIKEY'],
  domain:         'heroku.com',
  authentication: :plain
}

mailcatcher_settings = {
  address: '127.0.0.1',
  port: 1025,
  domain: "factlink.com"
}

if ['production', 'staging'].include? Rails.env
  ActionMailer::Base.smtp_settings = sendgrid_settings
else
  ActionMailer::Base.smtp_settings = mailcatcher_settings
end
