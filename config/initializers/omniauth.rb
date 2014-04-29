omniauth_conf = ActiveSupport::HashWithIndifferentAccess.new({
  development: {
    facebook: {
      id: "283748838400237",
      secret: "9d3776e82a8e050f615838bb9b32d13f",
    },
    twitter: {
      id: "e88X667rNJwV3qUU1FP38Q",
      secret: "PzyaLeimuKB9vFnaQQePk76QSXwp11nUZKxpk83E",
    },
  },
  test: {
    facebook: {
      id: "283748838400237",
      secret: "9d3776e82a8e050f615838bb9b32d13f",
    },
    twitter: {
      id: "e88X667rNJwV3qUU1FP38Q",
      secret: "PzyaLeimuKB9vFnaQQePk76QSXwp11nUZKxpk83E",
    },
  },
  staging: {
    facebook: {
      id: "435991923110591",
      secret: "e27771470b8c341cb144367f7938a900",
    },
    twitter: {
      id: "tn5TO9XnyZhyCvGlZqkQ",
      secret: "WJj6vPjrxn13gI99w0ZZuWjqccU8EX6voY62WztaRc",
    },
  },
  production: {
    facebook: {
      id: "385144638222636",
      secret: "caeb481a2676854f6724b52838407faa",
    },
    twitter: {
      id: "gbis6EUPWZvEJFApQ3KA",
      secret: "YVdJAHDFKqwZJPE1rqbojYXxj8wx7430PjH1cEaHI",
    },
  }
})

twitter_conf =
  if ENV['TWITTER_ID'] && ENV['TWITTER_SECRET']
    ActiveSupport::HashWithIndifferentAccess.new({
      id: ENV['TWITTER_ID'],
      secret: ENV['TWITTER_SECRET'],
    })
  else
    omniauth_conf[Rails.env][:twitter]
  end

facebook_conf =
  if ENV['FACEBOOK_ID'] && ENV['FACEBOOK_SECRET']
    ActiveSupport::HashWithIndifferentAccess.new({
      id: ENV['FACEBOOK_ID'],
      secret: ENV['FACEBOOK_SECRET'],
    })
  else
    omniauth_conf[Rails.env][:facebook]
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
