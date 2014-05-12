FactlinkUI::Application.config.facebook_app_id = ENV['FACEBOOK_ID']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_ID'], ENV['TWITTER_SECRET']
  provider :facebook,
    ENV['FACEBOOK_ID'],
    ENV['FACEBOOK_SECRET'],
    scope: 'email',
    display: 'popup'
end

OmniAuth.config.on_failure = Accounts::SocialConnectionsController.action(:oauth_failure)

FactlinkUI::Application.config.social_services = %w[facebook twitter]
