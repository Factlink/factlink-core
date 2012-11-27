require_relative 'pavlov'

class CreateCommentForFactInteractor
  include Pavlov::Interactor

  arguments :fact_id, :opinion, :content

  def execute
    comment = command :create_comment,@fact_id, @opinion,
      @content, @options[:current_user].id.to_s

    create_activity comment

    comment
  end

  def create_activity comment
    # TODO fix this ugly data access shit, need to think about where to kill objects, etc
    command :create_activity,
      @options[:current_user].graph_user, :created_comment,
      Comment.find(comment.id), comment.fact_data.fact
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
