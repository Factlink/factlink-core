require 'pavlov_helper'
require_relative '../../../app/interactors/queries/get_comments.rb'

describe Queries::GetComments do
  include PavlovSupport

  it 'initializes correctly' do
    query = Queries::GetComments.new 1, 'believes'

    query.should_not be_nil
  end

  it 'should raise a validation error with an invalid fact_id' do
    expect { Queries::GetComments.new 'a', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'should raise a validation error with an invalid opinion' do
    expect { Queries::GetComments.new 1, 'mwah'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_classes 'Authority'
    end

    it 'should return dead comments with authorities' do
      fact_id = 3
      opinion = 'believes'
      graph_user = mock()
      user = mock(:user)
      query = Queries::GetComments.new fact_id, opinion, current_user: user
      content = 'bla'
      comment_id = '1a'
      authority_string = '1.0'
      comment = mock(content: content, id: comment_id, opinion: opinion, authority: authority_string)

      query.should_receive(:comments).and_return([comment])
      query.should_receive(:query).with(:authority_of_created_user_for_comment, comment.id).and_return(authority_string)
      comment.should_receive(:authority=).with(authority_string)

      results = query.execute

      results.first.opinion.should eq opinion
      results.first.content.should eq content
      results.first.id.should eq comment_id
      results.first.authority.should eq authority_string
    end
  end

  describe '.comments' do
    before do
      stub_classes 'Comment', 'Fact'
    end

    it 'should return a comment' do
      fact = mock(id: 3)
      opinion = 'believes'
      fact_data_id = '3b'
      comment = mock()
      user = mock()

      query = Queries::GetComments.new fact.id, opinion, current_user: user

      Fact.should_receive(:[]).with(fact.id).and_return(stub(data_id: fact_data_id))
      Comment.should_receive(:where).
        with(fact_data_id: fact_data_id, opinion: opinion).
        and_return([comment])

      query.comments.should eq [comment]
    end
  end
end
