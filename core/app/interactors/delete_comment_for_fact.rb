require_relative 'pavlov'

class DeleteCommentForFact
  include Pavlov::Interactor

  arguments :comment_id

  def execute
    command :delete_command, @comment_id, @options[:current_user].id
  end

  def validate
    validate_hexadecimal_string :comment_id, @comment_id
  end

  def authorized?
    @options[:current_user]
  end
end
