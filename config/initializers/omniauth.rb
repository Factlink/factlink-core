omniauth_conf_complete = ActiveSupport::HashWithIndifferentAccess.new({
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

omniauth_conf = omniauth_conf_complete[Rails.env]


FactlinkUI::Application.config.omniauth_conf = omniauth_conf

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, omniauth_conf['twitter']['id'], omniauth_conf['twitter']['secret']
  provider :facebook,
    omniauth_conf['facebook']['id'],
    omniauth_conf['facebook']['secret'],
    scope: 'email',
    display: 'popup'

end

OmniAuth.config.on_failure = Accounts::SocialConnectionsController.action(:oauth_failure)

FactlinkUI::Application.config.social_services = %w[facebook twitter]
