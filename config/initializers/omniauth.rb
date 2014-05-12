twitter_conf =
  if ENV['TWITTER_ID'] && ENV['TWITTER_SECRET']
    ActiveSupport::HashWithIndifferentAccess.new({
      id: ENV['TWITTER_ID'],
      secret: ENV['TWITTER_SECRET'],
    })
  else
    # Development app
    ActiveSupport::HashWithIndifferentAccess.new({
      id: "e88X667rNJwV3qUU1FP38Q",
      secret: "PzyaLeimuKB9vFnaQQePk76QSXwp11nUZKxpk83E",
    })
  end

facebook_conf =
  if ENV['FACEBOOK_ID'] && ENV['FACEBOOK_SECRET']
    ActiveSupport::HashWithIndifferentAccess.new({
      id: ENV['FACEBOOK_ID'],
      secret: ENV['FACEBOOK_SECRET'],
    })
  else
    # Development app
    ActiveSupport::HashWithIndifferentAccess.new({
      id: "283748838400237",
      secret: "9d3776e82a8e050f615838bb9b32d13f",
    })
  end

FactlinkUI::Application.config.facebook_app_id = facebook_conf['id']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, twitter_conf['id'], twitter_conf['secret']
  provider :facebook,
    facebook_conf['id'],
    facebook_conf['secret'],
    scope: 'email',
    display: 'popup'
end

OmniAuth.config.on_failure = Accounts::SocialConnectionsController.action(:oauth_failure)

FactlinkUI::Application.config.social_services = %w[facebook twitter]
