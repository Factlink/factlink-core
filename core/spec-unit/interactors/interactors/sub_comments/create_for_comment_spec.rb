require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/create_for_comment'

describe Interactors::SubComments::CreateForComment do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'SubComment'
  end

  it '.authorized denied the user cannot show the comment' do
    comment = mock
    ability = mock
    ability.stub(:can?).with(:show, comment).and_return(false)
    Comment.should_receive(:find).and_return(comment)

    interactor = described_class.new comment_id: '2a', content: 'hoi',
        pavlov_options: { current_user: nil, ability: ability }

    expect { interactor.call }
     .to raise_error Pavlov::AccessDenied, 'Unauthorized'
  end

  describe '.validate' do
    it 'without comment_id doesn''t validate' do
      expect_validating(comment_id: nil, content: 'hoi').
        to fail_validation('comment_id should be an hexadecimal string.')
    end

    it 'without content doesn''t validate' do
      expect_validating(comment_id: '2a', content: '').
        to fail_validation('content should not be empty.')
    end

    it 'without content doesn\'t validate' do
      expect_validating(comment_id: '2a', content: '  ').
        to fail_validation('content should not be empty.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'KillObject', 'Commands::SubComments::CreateXxx'
    end

    it 'calls the corresponding command' do
      comment = mock id: '2a'
      user = mock
      sub_comment = mock
      authority = mock
      dead_sub_comment = mock
      content = 'hoi'

      ability = mock
      ability.stub(:can?).with(:show, comment).and_return(true)
      ability.stub(:can?).with(:create, SubComment).and_return(true)

      Comment.should_receive(:find).with(comment.id).and_return(comment)

      interactor = described_class.new comment_id: comment.id, content: content,
        pavlov_options: { current_user: user, ability: ability }

      interactor.should_receive(:old_command).with(:"sub_comments/create_xxx", comment.id, 'Comment', content, user).
        and_return(sub_comment)
      interactor.should_receive(:authority_of_user_who_created).with(sub_comment).
        and_return(authority)
      interactor.should_receive(:create_activity).with(sub_comment)
      KillObject.should_receive(:sub_comment).with(sub_comment, authority: authority).
        and_return(dead_sub_comment)

      result = interactor.execute

      expect(result).to eq dead_sub_comment
    end

    it 'throws an error when the fact relation does not exist' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      Comment.stub find: nil
      ability = stub can?: true

      interactor = described_class.new comment_id: '2a', content: 'content',
        pavlov_options: { current_user: mock, ability: ability }
      interactor.stub comment: nil

      expect { interactor.call }
       .to raise_error(Pavlov::ValidationError, "parent does not exist any more")
    end
  end

  describe '.top_fact' do
    it 'returns the top fact for the comment_id' do
      comment_id = '2a'
      fact = mock
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)
      ability = stub can?: true

      interactor = described_class.new comment_id: comment_id, content: 'hoi',
        pavlov_options: { current_user: mock, ability: ability }

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      comment_id = '2a'
      fact = mock
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)
      ability = stub can?: true

      interactor = described_class.new comment_id: comment_id, content: 'hoi',
        pavlov_options: { current_user: mock, ability: ability }

      result = interactor.top_fact

      result2 = interactor.top_fact

      result2.should eq fact
    end
  end

  describe '.authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
    end

    it 'retrieves the authority and kills the subcomment' do
      comment_id = '2a'
      fact = mock
      graph_user = mock
      authority = mock
      user = mock
      sub_comment = mock(created_by: mock(graph_user: graph_user))

      Comment.stub find: nil
      ability = stub can?: true

      interactor = described_class.new comment_id: comment_id, content: 'hoi',
        pavlov_options: { current_user: user, ability: ability }

      interactor.should_receive(:top_fact).and_return(fact)
      interactor.should_receive(:old_query).with(:authority_on_fact_for, fact, graph_user).
        and_return(authority)

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
