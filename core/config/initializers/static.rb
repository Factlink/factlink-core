static_conf = YAML::load_file(Rails.root.join('config/static.yml'))[Rails.env]['static']
FactlinkUI::Application.config.static_url =
    static_conf['protocol'] + static_conf['hostname'] +
       ':' + static_conf['port'].to_s

gibber_cipher = Gibberish::AES.new(static_conf['secret'])


FactlinkUI::Application.config.jslib_url_builder = JsLibUrl::Builder.new({
  base_url: FactlinkUI::Application.config.static_url + '/jslib/',
  salt: Base64.urlsafe_encode64(gibber_cipher.enc(static_conf['salt'])).gsub(/=/,''),
  secret: static_conf['secret']
})