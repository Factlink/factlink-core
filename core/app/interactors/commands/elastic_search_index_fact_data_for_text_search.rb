require_relative 'elastic_search_index_for_text_search_command.rb'

class ElasticSearchIndexFactDataForTextSearch < ElasticSearchIndexForTextSearchCommand
  def define_index
    type 'factdata'
    field :displaystring
    field :title
  end
end
