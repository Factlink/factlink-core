require_relative '../pavlov'

module Interactors
class CreateCommentForFact
  include Pavlov::Interactor

  arguments :fact_id, :opinion, :content

  def execute
    comment = command :create_comment, @fact_id, @opinion,
      @content, @options[:current_user].id.to_s

    comment.authority = authority_of comment

    create_activity comment

    comment
  end

  def authority_of comment
    query :authority_on_fact_for, fact, comment.created_by.graph_user
  end

  def fact
    Fact[@fact_id]
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
end
