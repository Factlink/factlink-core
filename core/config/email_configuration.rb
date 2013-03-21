
sendgrid_settings = {
  user_name: "factlink",
  password: '4q"_NdREV89[s0zq',
  domain: "factlink.com",
  address: "smtp.sendgrid.com",
  port: 465,
  authentication: :plain,
  enable_starttls_auto: true,
}

mandrill_settings = {
  user_name: "mark@factlink.com",
  password: 'YKJLeC_CBFnr1sxc6dtjXw',
  domain: "factlink.com",
  address: "smtp.mandrillapp.com",
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.smtp_settings = mandrill_settings
