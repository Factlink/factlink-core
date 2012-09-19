elasticsearch_conf = YAML::load_file(Rails.root.join('config/elasticsearch.yml'))[Rails.env]['elasticsearch']

connection_hash = {
  host: elasticsearch_conf['host'],
  port: elasticsearch_conf['port'],
  cluster: elasticsearch_conf['cluster']
}

FactlinkUI::Application.config.elasticsearch_url = "#{connection_hash[:host]}:#{connection_hash[:port]}"
