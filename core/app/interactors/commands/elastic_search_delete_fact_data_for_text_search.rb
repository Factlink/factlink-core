require_relative 'elastic_search_delete_for_text_search.rb'

class ElasticSearchDeleteFactDataForTextSearch < ElasticSearchDeleteForTextSearch

  def define_index
    type 'factdata'
  end

end
