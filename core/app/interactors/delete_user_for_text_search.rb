require_relative 'delete_for_text_search_command.rb'

class DeleteUserForTextSearch < DeleteForTextSearchCommand

  def define_index
    type 'user'
  end

end
