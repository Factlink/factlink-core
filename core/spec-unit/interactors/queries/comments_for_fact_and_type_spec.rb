require 'pavlov_helper'
require_relative '../../../app/interactors/queries/comments_for_fact_and_type.rb'

describe Queries::CommentsForFactAndType do
  include PavlovSupport

  it 'initializes correctly' do
    query = Queries::CommentsForFactAndType.new 1, 'believes'

    query.should_not be_nil
  end

  it 'should raise a validation error with an invalid fact_id' do
    expect { Queries::CommentsForFactAndType.new 'a', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'should raise a validation error with an invalid type' do
    expect { Queries::CommentsForFactAndType.new 1, 'mwah'}.
      to raise_error(Pavlov::ValidationError, 'type should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_classes 'Authority'
    end

    it 'should return dead comments with authorities' do
      pending
      fact = mock(:fact, id: 3)
      type = 'believes'
      graph_user = mock()
      user = mock(:user, graph_user: graph_user)
      query = Queries::CommentsForFactAndType.new fact.id, type, current_user: user
      content = 'bla'
      comment_id = '1a'
      authority_string = '1.0'
      comment = mock(created_by: user, content: content, id: comment_id, type: type, authority: authority_string)

      query.should_receive(:comments).and_return([comment])
      query.should_receive(:fact).and_return(fact)
      query.should_receive(:query).with(:authority_on_fact_for, fact, graph_user).and_return(authority_string)
      comment.should_receive(:authority=).with(authority_string)

      results = query.execute

      results.first.type.should eq type
      results.first.content.should eq content
      results.first.id.should eq comment_id
      results.first.authority.should eq authority_string
    end
  end

  describe '.comments' do
    before do
      stub_classes 'Comment'
    end

    it 'should return the comments' do
      fact = mock(id: 3)
      type = 'believes'
      fact_data_id = '3b'
      comment = mock()
      user = mock()

      query = Queries::CommentsForFactAndType.new fact.id, type, current_user: user

      query.should_receive(:fact).and_return(stub(data_id: fact_data_id))
      Comment.should_receive(:where).
        with(fact_data_id: fact_data_id, type: type).
        and_return([comment])

      query.comments.should eq [comment]
    end
  end

  describe '.fact' do
    before do
      stub_classes 'Fact'
    end

    it 'should return the fact' do
      fact = mock(id: 3)
      type = 'believes'
      comment = mock()
      user = mock()

      query = Queries::CommentsForFactAndType.new fact.id, type, current_user: user

      Fact.should_receive(:[]).with(fact.id).and_return(fact)

      query.fact.should eq fact
    end
  end
end
