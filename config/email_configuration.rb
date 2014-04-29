mandrill_settings = {
  user_name: "mark@factlink.com",
  password: 'YKJLeC_CBFnr1sxc6dtjXw',
  domain: "factlink.com",
  address: "smtp.mandrillapp.com",
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

mailcatcher_settings = {
  :address => '127.0.0.1',
  :port => 1025,
  :domain => "hackerone.com"
}

if ['production', 'staging'].include? Rails.env
  ActionMailer::Base.smtp_settings = mandrill_settings
else
  ActionMailer::Base.smtp_settings = mailcatcher_settings
end
