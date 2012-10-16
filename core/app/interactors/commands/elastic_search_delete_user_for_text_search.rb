require_relative 'elastic_search_delete_for_text_search.rb'

class ElasticSearchDeleteUserForTextSearch < ElasticSearchDeleteForTextSearch

  def define_index
    type 'user'
  end

end
