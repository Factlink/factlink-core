require_relative 'index_for_text_search_command.rb'

class IndexFactDataForTextSearch < IndexForTextSearchCommand
  def define_index
    name 'factdata'
    field :displaystring
    field :title
  end
end
