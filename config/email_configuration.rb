mandrill_settings = {
  :port =>           '587',
  :address =>        'smtp.mandrillapp.com',
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>       ENV['MANDRILL_APIKEY'],
  :domain =>         'heroku.com',
  :authentication => :plain
}

mailcatcher_settings = {
  :address => '127.0.0.1',
  :port => 1025,
  :domain => "factlink.com"
}

if ['production', 'staging'].include? Rails.env
  ActionMailer::Base.smtp_settings = mandrill_settings
else
  ActionMailer::Base.smtp_settings = mailcatcher_settings
end
