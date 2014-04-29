if ENV['MANDRILL_USERNAME'] && ENV['MANDRILL_APIKEY']
  mandrill_settings = {
    :port =>           '587',
    :address =>        'smtp.mandrillapp.com',
    :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'heroku.com',
    :authentication => :plain
  }
else
  mandrill_settings = {
    user_name: "mark@factlink.com",
    password: 'YKJLeC_CBFnr1sxc6dtjXw',
    domain: "factlink.com",
    address: "smtp.mandrillapp.com",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }
end

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
