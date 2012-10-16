require_relative 'delete_for_text_search_command.rb'

class DeleteFactDataForTextSearch < DeleteForTextSearchCommand

  def define_index
    type 'factdata'
  end

end
