ActionMailer::Base.smtp_settings = {
  user_name: "factlink",
  password: '4q"_NdREV89[s0zq',
  domain: "factlink.com",
  address: "smtp.sendgrid.com",
  port: 465,
  authentication: :plain,
  enable_starttls_auto: true,
  openssl_verify_mode: "none" # secure connection, but not verifying
}
