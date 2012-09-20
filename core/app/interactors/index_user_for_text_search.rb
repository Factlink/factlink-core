require_relative 'index_for_text_search_command.rb'

class IndexUserForTextSearch < IndexForTextSearchCommand
  def define_index
    name 'user'
    field :username
  end
end
