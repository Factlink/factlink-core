require_relative 'pavlov'

class CreateCommentForFactInteractor
  include Pavlov::Interactor

  arguments :fact_id, :opinion, :content

  def execute
    command :create_comment, @fact_id, @opinion, @content, @options[:current_user].id.to_s
  end

  def authorized?
    @options[:current_user]
  end

  def validate
    validate_regex   :content, @content, /\A.+\Z/,
      "should not be empty."
    validate_integer :fact_id, @fact_id
    validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
  end
end
