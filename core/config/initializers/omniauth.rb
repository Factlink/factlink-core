omniauth_conf = YAML::load_file(Rails.root.join('config/omniauth.yml'))[Rails.env]['omniauth']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, omniauth_conf['twitter']['id'], omniauth_conf['twitter']['secret']
  provider :facebook,
    omniauth_conf['facebook']['id'],
    omniauth_conf['facebook']['secret'],
    scope: 'user_birthday,user_education_history,user_interests,user_likes,user_status,publish_stream',
    display: 'popup'

end

OmniAuth.config.on_failure = IdentitiesController.action(:oauth_failure)

FactlinkUI::Application.config.social_services = %w[facebook twitter]
