require_relative 'pavlov'

class GetCommentsForFactInteractor
  include Pavlov::Interactor

  arguments :fact_id, :opinion

  def validate
    validate_integer :fact_id, @fact_id
    validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
  end

  def authorized?
    @options[:current_user]
  end

  def execute
    query :get_comments, @fact_id, @opinion
  end
end
