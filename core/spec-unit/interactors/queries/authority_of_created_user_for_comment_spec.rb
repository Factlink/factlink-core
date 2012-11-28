require 'pavlov_helper'
require_relative '../../../app/interactors/queries/authority_of_created_user_for_comment.rb'

describe Queries::AuthorityOfCreatedUserForComment do
  include PavlovSupport

  it 'initializes correctly' do
    query = Queries::AuthorityOfCreatedUserForComment.new '1a'

    query.should_not be_nil
  end

  it 'should raise a validation error with an invalid comment_id' do
    expect { Queries::AuthorityOfCreatedUserForComment.new 'g'}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  describe '.execute' do
    before do
      stub_classes 'Comment', 'Authority'
    end

    it 'should return the authority of the current_user on a comment' do
      fact = mock()
      fact_data = mock(fact: fact)
      graph_user = mock()
      user = mock(:user, graph_user: graph_user)
      comment = mock(id: '1a', fact_data: fact_data, created_by: user)

      authority = mock
      authority_string = '1.0'

      query = Queries::AuthorityOfCreatedUserForComment.new comment.id

      Comment.should_receive(:find).with(comment.id).and_return(comment)
      Authority.should_receive(:on).with(fact, for: graph_user).and_return(authority)
      authority.should_receive(:to_s).with(1.0).and_return(authority_string)

      query.execute.should eq authority_string
    end
  end
end
