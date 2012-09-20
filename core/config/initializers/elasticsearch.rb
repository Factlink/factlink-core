elasticsearch_conf = YAML::load_file(Rails.root.join('config/elasticsearch.yml'))[Rails.env]['elasticsearch']

connection_hash = {
  hostname: elasticsearch_conf['hostname'],
  port: elasticsearch_conf['port'],
  cluster: elasticsearch_conf['cluster']
}

FactlinkUI::Application.config.elasticsearch_url = "#{connection_hash[:hostname]}:#{connection_hash[:port]}/#{Rails.env}"
