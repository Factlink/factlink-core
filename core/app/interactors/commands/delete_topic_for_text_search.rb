require_relative 'delete_for_text_search_command.rb'

class DeleteTopicForTextSearch < DeleteForTextSearchCommand

  def define_index
    type 'topic'
  end

end
