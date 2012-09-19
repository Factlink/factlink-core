require 'json'

class IndexTopicForTextSearch
  def initialize topic
    raise 'Topic should be of class Topic.' unless topic.kind_of? Topic

    @topic = topic
  end

  def execute
    document = { :title => @topic.title, :slug_title => @topic.slug_title }.to_json
    options = { :body => document}

    HTTParty.put "http://#{FactlinkUI::Application.config.elasticsearch_url}/topic/#{@topic.id}", options
  end
end
