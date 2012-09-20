require_relative 'index_for_text_search_command.rb'

class IndexTopicForTextSearch < IndexForTextSearchCommand
  def define_index
    name 'topic'
    field :title
    field :slug_title
  end
end
